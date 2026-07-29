import 'package:drift/drift.dart';
import '../../domain/models/attachment_model.dart';
import '../../domain/repositories/attachments_repository.dart';
import '../database/app_database.dart' hide Attachment;

class AttachmentsRepositoryImpl implements AttachmentsRepository {
  final AppDatabase _db;

  AttachmentsRepositoryImpl(this._db);

  @override
  Stream<List<Attachment>> watchAttachments(String noteId) {
    return (_db.select(_db.attachments)
          ..where((tbl) => tbl.noteId.equals(noteId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt)]))
        .watch()
        .map((rows) => rows.map((row) {
              return Attachment(
                id: row.id,
                noteId: row.noteId,
                filename: row.filename,
                mimeType: row.mimeType,
                localPath: row.localPath,
                size: row.size,
                createdAt: row.createdAt,
              );
            }).toList());
  }

  @override
  Future<void> addAttachment(Attachment attachment) async {
    await _db.into(_db.attachments).insert(
      AttachmentsCompanion.insert(
        id: attachment.id,
        noteId: attachment.noteId,
        filename: attachment.filename,
        mimeType: attachment.mimeType,
        localPath: attachment.localPath,
        size: attachment.size,
        createdAt: attachment.createdAt,
      ),
      mode: InsertMode.replace,
    );
  }

  @override
  Future<void> deleteAttachment(String id) async {
    await (_db.delete(_db.attachments)..where((tbl) => tbl.id.equals(id))).go();
  }
}
