import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/models/tag_model.dart';
import '../../../../domain/repositories/tags_repository.dart';
import '../../../../data/providers/repository_providers.dart';

final tagsListProvider = StreamProvider.autoDispose<List<Tag>>((ref) {
  final repo = ref.watch(tagsRepositoryProvider);
  return repo.watchTags();
});

final tagsViewModelProvider = Provider<TagsViewModel>((ref) {
  return TagsViewModel(ref.watch(tagsRepositoryProvider));
});

class TagsViewModel {
  final TagsRepository _repository;

  TagsViewModel(this._repository);

  Future<void> createTag(String name) async {
    final tag = Tag(
      id: const Uuid().v4(),
      name: name,
    );
    await _repository.createTag(tag);
  }

  Future<void> updateTag(Tag tag, String newName) async {
    await _repository.updateTag(tag.copyWith(
      name: newName,
    ));
  }

  Future<void> deleteTag(String id) async {
    await _repository.deleteTag(id);
  }
}
