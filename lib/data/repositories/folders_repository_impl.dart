import 'package:drift/drift.dart';
import '../../domain/models/folder_model.dart' as domain;
import '../../domain/repositories/folders_repository.dart';
import '../database/app_database.dart';

class FoldersRepositoryImpl implements FoldersRepository {
  final AppDatabase _db;

  FoldersRepositoryImpl(this._db);

  domain.Folder _mapToDomain(Folder dto) {
    return domain.Folder(
      id: dto.id,
      name: dto.name,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  FoldersCompanion _mapToCompanion(domain.Folder folder) {
    return FoldersCompanion(
      id: Value(folder.id),
      name: Value(folder.name),
      createdAt: Value(folder.createdAt),
      updatedAt: Value(folder.updatedAt),
    );
  }

  @override
  Stream<List<domain.Folder>> watchFolders() {
    final query = _db.select(_db.folders)
      ..orderBy([(t) => OrderingTerm(expression: t.name.lower(), mode: OrderingMode.asc)]);
    return query.watch().map((folders) => folders.map(_mapToDomain).toList());
  }

  @override
  Future<domain.Folder?> getFolderById(String id) async {
    final folder = await (_db.select(_db.folders)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return folder != null ? _mapToDomain(folder) : null;
  }

  @override
  Future<void> createFolder(domain.Folder folder) async {
    await _db.into(_db.folders).insert(_mapToCompanion(folder));
  }

  @override
  Future<void> updateFolder(domain.Folder folder) async {
    await _db.update(_db.folders).replace(_mapToCompanion(folder));
  }

  @override
  Future<void> deleteFolder(String id) async {
    // When deleting a folder, we nullify the folderId on associated notes
    await (_db.update(_db.notes)..where((tbl) => tbl.folderId.equals(id)))
        .write(const NotesCompanion(folderId: Value(null)));
        
    await (_db.delete(_db.folders)..where((tbl) => tbl.id.equals(id))).go();
  }
}
