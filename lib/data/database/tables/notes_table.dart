import 'package:drift/drift.dart';
import 'folders_table.dart';

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get content => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get folderId => text().nullable().references(Folders, #id)();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isEncrypted => boolean().withDefault(const Constant(false))(); // For future AES support
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get noteType => text().withDefault(const Constant('text'))();
  DateTimeColumn get reminder => dateTime().nullable()();
  TextColumn get color => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
