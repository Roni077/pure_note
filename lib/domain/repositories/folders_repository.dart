import '../models/folder_model.dart';

abstract class FoldersRepository {
  Stream<List<Folder>> watchFolders();
  Future<Folder?> getFolderById(String id);
  Future<void> createFolder(Folder folder);
  Future<void> updateFolder(Folder folder);
  Future<void> deleteFolder(String id);
}
