import '../models/tag_model.dart';

abstract class TagsRepository {
  Stream<List<Tag>> watchTags();
  Future<Tag?> getTagById(String id);
  Future<void> createTag(Tag tag);
  Future<void> updateTag(Tag tag);
  Future<void> deleteTag(String id);
  
  Future<void> addTagToNote(String noteId, String tagId);
  Future<void> removeTagFromNote(String noteId, String tagId);
  Future<List<Tag>> getTagsForNote(String noteId);
}
