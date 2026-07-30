import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../domain/services/backup_service.dart';
import '../database/app_database.dart';

class BackupServiceImpl implements BackupService {
  final AppDatabase _db;

  BackupServiceImpl(this._db);

  @override
  Future<String> createBackup() async {
    // 1. Gather data
    final notes = await _db.select(_db.notes).get();
    final folders = await _db.select(_db.folders).get();
    final tags = await _db.select(_db.tags).get();
    final noteTags = await _db.select(_db.noteTags).get();
    final attachments = await _db.select(_db.attachments).get();

    final Map<String, dynamic> backupData = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'tables': {
        'notes': notes.map((e) => e.toJson()).toList(),
        'folders': folders.map((e) => e.toJson()).toList(),
        'tags': tags.map((e) => e.toJson()).toList(),
        'noteTags': noteTags.map((e) => e.toJson()).toList(),
        'attachments': attachments.map((e) => e.toJson()).toList(),
      }
    };

    // 2. Gather attachments and encode as base64
    final Map<String, String> filesData = {};
    final appDocsDir = await getApplicationDocumentsDirectory();
    final attachmentsDir = Directory('${appDocsDir.path}/attachments');
    if (await attachmentsDir.exists()) {
      await for (final entity in attachmentsDir.list(recursive: true)) {
        if (entity is File) {
          final relativePath = p.relative(entity.path, from: appDocsDir.path);
          final bytes = await entity.readAsBytes();
          filesData[relativePath.replaceAll('\\', '/')] = base64Encode(bytes);
        }
      }
    }
    backupData['files'] = filesData;

    final jsonData = jsonEncode(backupData);

    // 3. Save to temp directory
    final tempDir = await getTemporaryDirectory();
    final fileName = 'purenote_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final filePath = p.join(tempDir.path, fileName);
    
    final file = File(filePath);
    await file.writeAsString(jsonData);

    return filePath;
  }

  @override
  Future<void> restoreBackup(String filePath) async {
    final jsonData = await File(filePath).readAsString();
    final decoded = jsonDecode(jsonData) as Map<String, dynamic>;

    // Restore files
    final filesData = decoded['files'] as Map<String, dynamic>?;
    if (filesData != null) {
      final appDocsDir = await getApplicationDocumentsDirectory();
      for (final entry in filesData.entries) {
        final outFile = File(p.join(appDocsDir.path, entry.key));
        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(base64Decode(entry.value as String));
      }
    }

    final tables = decoded['tables'] as Map<String, dynamic>?;
    if (tables == null) {
      throw Exception('Invalid backup file: missing tables data');
    }

    await _db.transaction(() async {
      // Restore Folders
      final foldersData = tables['folders'] as List?;
      if (foldersData != null) {
        for (final item in foldersData) {
          final folder = Folder.fromJson(item as Map<String, dynamic>);
          await _db.into(_db.folders).insert(folder, mode: InsertMode.insertOrReplace);
        }
      }

      // Restore Tags
      final tagsData = tables['tags'] as List?;
      if (tagsData != null) {
        for (final item in tagsData) {
          final tag = Tag.fromJson(item as Map<String, dynamic>);
          await _db.into(_db.tags).insert(tag, mode: InsertMode.insertOrReplace);
        }
      }

      // Restore Notes
      final notesData = tables['notes'] as List?;
      if (notesData != null) {
        for (final item in notesData) {
          final note = Note.fromJson(item as Map<String, dynamic>);
          await _db.into(_db.notes).insert(note, mode: InsertMode.insertOrReplace);
        }
      }

      // Restore NoteTags
      final noteTagsData = tables['noteTags'] as List?;
      if (noteTagsData != null) {
        for (final item in noteTagsData) {
          final noteTag = NoteTag.fromJson(item as Map<String, dynamic>);
          await _db.into(_db.noteTags).insert(noteTag, mode: InsertMode.insertOrReplace);
        }
      }

      // Restore Attachments
      final attachmentsData = tables['attachments'] as List?;
      if (attachmentsData != null) {
        for (final item in attachmentsData) {
          final attachment = Attachment.fromJson(item as Map<String, dynamic>);
          await _db.into(_db.attachments).insert(attachment, mode: InsertMode.insertOrReplace);
        }
      }
    });
  }
}
