import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/models/folder_model.dart';
import '../../../../domain/repositories/folders_repository.dart';
import '../../../../data/providers/repository_providers.dart';

final foldersListProvider = StreamProvider.autoDispose<List<Folder>>((ref) {
  final repo = ref.watch(foldersRepositoryProvider);
  return repo.watchFolders();
});

final foldersViewModelProvider = Provider<FoldersViewModel>((ref) {
  return FoldersViewModel(ref.watch(foldersRepositoryProvider));
});

class FoldersViewModel {
  final FoldersRepository _repository;

  FoldersViewModel(this._repository);

  Future<void> createFolder(String name) async {
    final folder = Folder(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _repository.createFolder(folder);
  }

  Future<void> updateFolder(Folder folder, String newName) async {
    await _repository.updateFolder(folder.copyWith(
      name: newName,
      updatedAt: DateTime.now(),
    ));
  }

  Future<void> deleteFolder(String id) async {
    await _repository.deleteFolder(id);
  }
}
