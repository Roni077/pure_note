import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../domain/models/note_model.dart';
import '../../../../domain/models/attachment_model.dart';
import '../../../../domain/repositories/notes_repository.dart';
import '../../../../data/providers/repository_providers.dart';

final attachmentsProvider = StreamProvider.autoDispose.family<List<Attachment>, String>((ref, noteId) {
  final repo = ref.watch(attachmentsRepositoryProvider);
  return repo.watchAttachments(noteId);
});

final noteEditorProvider = StateNotifierProvider.autoDispose.family<NoteEditorViewModel, AsyncValue<Note?>, String?>((ref, id) {
  return NoteEditorViewModel(ref.watch(notesRepositoryProvider), id);
});

class NoteEditorViewModel extends StateNotifier<AsyncValue<Note?>> {
  final NotesRepository _repository;
  final String? _initialId;

  NoteEditorViewModel(this._repository, this._initialId) : super(const AsyncValue.loading()) {
    _loadNote();
  }

  Future<void> _loadNote() async {
    if (_initialId == null) {
      // Creating a new note
      state = const AsyncValue.data(null);
      return;
    }

    try {
      final note = await _repository.getNoteById(_initialId!);
      state = AsyncValue.data(note);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Note> saveNote({
    required String title,
    required String content,
    String? folderId,
    List<String>? tags,
    bool? isPinned,
    bool? isFavourite,
    bool? isArchived,
    bool? isLocked,
  }) async {
    final now = DateTime.now();
    
    final currentNote = state.value;
    
    if (currentNote == null) {
      // Create new
      final newNote = Note(
        id: const Uuid().v4(),
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
        folderId: folderId,
        tags: tags ?? [],
        isPinned: isPinned ?? false,
        isFavourite: isFavourite ?? false,
        isArchived: isArchived ?? false,
        isLocked: isLocked ?? false,
      );
      await _repository.createNote(newNote);
      state = AsyncValue.data(newNote);
      return newNote;
    } else {
      // Update existing
      final updatedNote = currentNote.copyWith(
        title: title,
        content: content,
        updatedAt: now,
        folderId: folderId,
        tags: tags ?? currentNote.tags,
        isPinned: isPinned ?? currentNote.isPinned,
        isFavourite: isFavourite ?? currentNote.isFavourite,
        isArchived: isArchived ?? currentNote.isArchived,
        isLocked: isLocked ?? currentNote.isLocked,
      );
      await _repository.updateNote(updatedNote);
      state = AsyncValue.data(updatedNote);
      return updatedNote;
    }
  }
}
