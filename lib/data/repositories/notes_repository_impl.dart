import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/note_model.dart' as domain;
import '../../domain/repositories/notes_repository.dart';
import '../database/app_database.dart';

class NotesRepositoryImpl implements NotesRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  NotesRepositoryImpl(this._db);

  domain.Note _mapToDomain(Note dto, List<String> tags) {
    return domain.Note(
      id: dto.id,
      title: dto.title,
      content: dto.content,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      folderId: dto.folderId,
      isPinned: dto.isPinned,
      isFavourite: dto.isFavourite,
      isArchived: dto.isArchived,
      isLocked: dto.isLocked,
      isEncrypted: dto.isEncrypted,
      isDeleted: dto.isDeleted,
      noteType: dto.noteType,
      reminder: dto.reminder,
      color: dto.color,
      tags: tags,
    );
  }

  NotesCompanion _mapToCompanion(domain.Note note) {
    return NotesCompanion(
      id: Value(note.id),
      title: Value(note.title),
      content: Value(note.content),
      createdAt: Value(note.createdAt),
      updatedAt: Value(note.updatedAt),
      folderId: Value(note.folderId),
      isPinned: Value(note.isPinned),
      isFavourite: Value(note.isFavourite),
      isArchived: Value(note.isArchived),
      isLocked: Value(note.isLocked),
      isEncrypted: Value(note.isEncrypted),
      isDeleted: Value(note.isDeleted),
      noteType: Value(note.noteType),
      reminder: Value(note.reminder),
      color: Value(note.color),
    );
  }

  @override
  Stream<List<domain.Note>> watchNotes({
    NoteFilter filter = NoteFilter.all,
    NoteSortOrder sort = NoteSortOrder.recentlyUpdated,
    String? folderId,
    String? tagId,
  }) {
    final query = _db.select(_db.notes);
    
    // Apply filters
    if (filter != NoteFilter.deleted) {
      query.where((tbl) => tbl.isDeleted.equals(false));
    }
    
    switch (filter) {
      case NoteFilter.pinned:
        query.where((tbl) => tbl.isPinned.equals(true));
        break;
      case NoteFilter.favourite:
        query.where((tbl) => tbl.isFavourite.equals(true));
        break;
      case NoteFilter.archived:
        query.where((tbl) => tbl.isArchived.equals(true));
        break;
      case NoteFilter.locked:
        query.where((tbl) => tbl.isLocked.equals(true));
        break;
      case NoteFilter.checklist:
        query.where((tbl) => tbl.noteType.equals('checklist'));
        break;
      case NoteFilter.deleted:
        query.where((tbl) => tbl.isDeleted.equals(true));
        break;
      case NoteFilter.all:
      case NoteFilter.attachments: // Handle attachments filter later if needed via joins
        break;
    }

    if (folderId != null) {
      query.where((tbl) => tbl.folderId.equals(folderId));
    }

    // Apply sorting
    switch (sort) {
      case NoteSortOrder.recentlyUpdated:
        query.orderBy([(tbl) => OrderingTerm(expression: tbl.updatedAt, mode: OrderingMode.desc)]);
        break;
      case NoteSortOrder.recentlyCreated:
        query.orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)]);
        break;
      case NoteSortOrder.oldest:
        query.orderBy([(tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.asc)]);
        break;
      case NoteSortOrder.alphabetical:
        query.orderBy([(tbl) => OrderingTerm(expression: tbl.title.lower(), mode: OrderingMode.asc)]);
        break;
      case NoteSortOrder.reverseAlphabetical:
        query.orderBy([(tbl) => OrderingTerm(expression: tbl.title.lower(), mode: OrderingMode.desc)]);
        break;
    }

    return query.watch().asyncMap((notes) async {
      final List<domain.Note> domainNotes = [];
      for (final note in notes) {
        final tagQuery = _db.select(_db.noteTags).join([
          innerJoin(_db.tags, _db.tags.id.equalsExp(_db.noteTags.tagId)),
        ])..where(_db.noteTags.noteId.equals(note.id));
        
        final tagResults = await tagQuery.get();
        final tagIds = tagResults.map((row) => row.readTable(_db.tags).id).toList();
        
        if (tagId != null) {
          final hasTag = tagResults.any((row) => row.readTable(_db.tags).id == tagId);
          if (!hasTag) continue;
        }
        
        domainNotes.add(_mapToDomain(note, tagIds));
      }
      return domainNotes;
    });
  }

  @override
  Future<domain.Note?> getNoteById(String id) async {
    final note = await (_db.select(_db.notes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (note == null) return null;
    
    final tagQuery = _db.select(_db.noteTags).join([
      innerJoin(_db.tags, _db.tags.id.equalsExp(_db.noteTags.tagId)),
    ])..where(_db.noteTags.noteId.equals(note.id));
    
    final tagResults = await tagQuery.get();
    final tagIds = tagResults.map((row) => row.readTable(_db.tags).id).toList();
    
    return _mapToDomain(note, tagIds);
  }

  @override
  Future<void> createNote(domain.Note note) async {
    await _db.transaction(() async {
      await _db.into(_db.notes).insert(_mapToCompanion(note));
      for (final tagId in note.tags) {
        await _db.into(_db.noteTags).insert(NoteTagsCompanion(
          noteId: Value(note.id),
          tagId: Value(tagId),
        ));
      }
    });
  }

  @override
  Future<void> updateNote(domain.Note note) async {
    await _db.transaction(() async {
      await _db.update(_db.notes).replace(_mapToCompanion(note));
      await (_db.delete(_db.noteTags)..where((tbl) => tbl.noteId.equals(note.id))).go();
      for (final tagId in note.tags) {
        await _db.into(_db.noteTags).insert(NoteTagsCompanion(
          noteId: Value(note.id),
          tagId: Value(tagId),
        ));
      }
    });
  }

  @override
  Future<void> deleteNote(String id, {bool hardDelete = false}) async {
    if (hardDelete) {
      await (_db.delete(_db.noteTags)..where((tbl) => tbl.noteId.equals(id))).go();
      await (_db.delete(_db.notes)..where((tbl) => tbl.id.equals(id))).go();
    } else {
      await (_db.update(_db.notes)..where((tbl) => tbl.id.equals(id)))
          .write(const NotesCompanion(isDeleted: Value(true)));
    }
  }

  @override
  Future<void> duplicateNote(String id) async {
    final existing = await getNoteById(id);
    if (existing == null) return;
    
    final newNote = existing.copyWith(
      id: _uuid.v4(),
      title: '${existing.title} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await createNote(newNote);
    
    // Duplicate tags
    final tags = await (_db.select(_db.noteTags)
      ..where((tbl) => tbl.noteId.equals(existing.id))).get();
    for (final tag in tags) {
      await _db.into(_db.noteTags).insert(NoteTagsCompanion(
        noteId: Value(newNote.id),
        tagId: Value(tag.tagId),
      ));
    }
  }

  @override
  Future<List<domain.Note>> searchNotes(String query) async {
    if (query.trim().isEmpty) return [];

    const ftsQuery = '''
      SELECT n.* FROM notes n
      INNER JOIN note_search_entries fts ON fts.id = n.id
      WHERE note_search_entries MATCH ?
      AND n.is_deleted = 0
      ORDER BY rank
    ''';

    final result = await _db.customSelect(
      ftsQuery,
      variables: [Variable.withString('${query.trim()}*')],
      readsFrom: {_db.notes},
    ).get();

    final List<domain.Note> domainNotes = [];
    for (final row in result) {
      final noteDto = _db.notes.map(row.data);
      
      final tagQuery = _db.select(_db.noteTags).join([
        innerJoin(_db.tags, _db.tags.id.equalsExp(_db.noteTags.tagId)),
      ])..where(_db.noteTags.noteId.equals(noteDto.id));
      
      final tagResults = await tagQuery.get();
      final tagIds = tagResults.map((tRow) => tRow.readTable(_db.tags).id).toList();
      
      domainNotes.add(_mapToDomain(noteDto, tagIds));
    }

    return domainNotes;
  }

  @override
  Future<void> cleanUpTrash(int days) async {
    if (days <= 0) return;
    final threshold = DateTime.now().subtract(Duration(days: days));
    
    final oldNotes = await (_db.select(_db.notes)
      ..where((tbl) => tbl.isDeleted.equals(true))
      ..where((tbl) => tbl.updatedAt.isSmallerThanValue(threshold)))
      .get();
      
    for (final note in oldNotes) {
      await deleteNote(note.id, hardDelete: true);
    }
  }
}
