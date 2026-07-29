import '../models/note_model.dart';

enum NoteSortOrder {
  recentlyUpdated,
  recentlyCreated,
  oldest,
  alphabetical,
  reverseAlphabetical,
}

enum NoteFilter {
  all,
  pinned,
  favourite,
  archived,
  locked,
  checklist,
  attachments,
  deleted,
}

abstract class NotesRepository {
  Stream<List<Note>> watchNotes({
    NoteFilter filter = NoteFilter.all,
    NoteSortOrder sort = NoteSortOrder.recentlyUpdated,
    String? folderId,
    String? tagId,
  });
  
  Future<Note?> getNoteById(String id);
  Future<void> createNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(String id, {bool hardDelete = false});
  Future<void> duplicateNote(String id);
  Future<void> cleanUpTrash(int days);
  Future<List<Note>> searchNotes(String query);
}
