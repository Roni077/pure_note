import 'package:drift/drift.dart';
import 'notes_table.dart';

class Attachments extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text().references(Notes, #id)();
  TextColumn get filename => text()();
  TextColumn get mimeType => text()();
  TextColumn get localPath => text()();
  IntColumn get size => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
