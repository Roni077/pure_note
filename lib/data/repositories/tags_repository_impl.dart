import 'package:drift/drift.dart';
import '../../domain/models/tag_model.dart' as domain;
import '../../domain/repositories/tags_repository.dart';
import '../database/app_database.dart';

class TagsRepositoryImpl implements TagsRepository {
  final AppDatabase _db;

  TagsRepositoryImpl(this._db);

  domain.Tag _mapToDomain(Tag dto) {
    return domain.Tag(
      id: dto.id,
      name: dto.name,
    );
  }

  TagsCompanion _mapToCompanion(domain.Tag tag) {
    return TagsCompanion(
      id: Value(tag.id),
      name: Value(tag.name),
    );
  }

  @override
  Stream<List<domain.Tag>> watchTags() {
    final query = _db.select(_db.tags)
      ..orderBy([(t) => OrderingTerm(expression: t.name.lower(), mode: OrderingMode.asc)]);
    return query.watch().map((tags) => tags.map(_mapToDomain).toList());
  }

  @override
  Future<domain.Tag?> getTagById(String id) async {
    final tag = await (_db.select(_db.tags)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return tag != null ? _mapToDomain(tag) : null;
  }

  @override
  Future<void> createTag(domain.Tag tag) async {
    await _db.into(_db.tags).insert(_mapToCompanion(tag));
  }

  @override
  Future<void> updateTag(domain.Tag tag) async {
    await _db.update(_db.tags).replace(_mapToCompanion(tag));
  }

  @override
  Future<void> deleteTag(String id) async {
    await (_db.delete(_db.noteTags)..where((tbl) => tbl.tagId.equals(id))).go();
    await (_db.delete(_db.tags)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<void> addTagToNote(String noteId, String tagId) async {
    await _db.into(_db.noteTags).insert(
      NoteTagsCompanion(
        noteId: Value(noteId),
        tagId: Value(tagId),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  @override
  Future<void> removeTagFromNote(String noteId, String tagId) async {
    await (_db.delete(_db.noteTags)
      ..where((tbl) => tbl.noteId.equals(noteId) & tbl.tagId.equals(tagId))).go();
  }

  @override
  Future<List<domain.Tag>> getTagsForNote(String noteId) async {
    final tagQuery = _db.select(_db.noteTags).join([
      innerJoin(_db.tags, _db.tags.id.equalsExp(_db.noteTags.tagId)),
    ])..where(_db.noteTags.noteId.equals(noteId));
    
    final results = await tagQuery.get();
    return results.map((row) => _mapToDomain(row.readTable(_db.tags))).toList();
  }
}
