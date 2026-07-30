import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/notes_table.dart';
import 'tables/folders_table.dart';
import 'tables/tags_table.dart';
import 'tables/note_tags_table.dart';
import 'tables/attachments_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Folders,
  Notes,
  Tags,
  NoteTags,
  Attachments,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      
      // Create FTS5 Search Table
      await customStatement('CREATE VIRTUAL TABLE note_search_entries USING fts5(id UNINDEXED, title, content, tokenize="unicode61");');
      
      // Auto-sync search index when Notes are inserted, updated, or deleted
      await customStatement('''
        CREATE TRIGGER notes_insert AFTER INSERT ON notes BEGIN
          INSERT INTO note_search_entries(id, title, content) VALUES (new.id, new.title, new.content);
        END;
      ''');
      await customStatement('''
        CREATE TRIGGER notes_delete AFTER DELETE ON notes BEGIN
          DELETE FROM note_search_entries WHERE id = old.id;
        END;
      ''');
      await customStatement('''
        CREATE TRIGGER notes_update AFTER UPDATE ON notes BEGIN
          DELETE FROM note_search_entries WHERE id = old.id;
          INSERT INTO note_search_entries(id, title, content) VALUES (new.id, new.title, new.content);
        END;
      ''');
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    }
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'purenote.sqlite'));
    
    if (Platform.isAndroid) {
      applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    
    return NativeDatabase.createInBackground(file);
  });
}
