import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/note_model.dart';
import '../../../../domain/repositories/notes_repository.dart';
import '../../../../data/providers/repository_providers.dart';

// State to hold current filters
class NotesListState {
  final NoteFilter filter;
  final NoteSortOrder sort;
  final String? folderId;
  final String? tagId;
  final bool isGridView;

  NotesListState({
    this.filter = NoteFilter.all,
    this.sort = NoteSortOrder.recentlyUpdated,
    this.folderId,
    this.tagId,
    this.isGridView = true,
  });

  NotesListState copyWith({
    NoteFilter? filter,
    NoteSortOrder? sort,
    String? folderId,
    String? tagId,
    bool? isGridView,
  }) {
    return NotesListState(
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      folderId: folderId ?? this.folderId,
      tagId: tagId ?? this.tagId,
      isGridView: isGridView ?? this.isGridView,
    );
  }
}

final notesFilterProvider = StateProvider<NotesListState>((ref) => NotesListState());

final notesListProvider = StreamProvider.autoDispose<List<Note>>((ref) {
  final repository = ref.watch(notesRepositoryProvider);
  final state = ref.watch(notesFilterProvider);

  return repository.watchNotes(
    filter: state.filter,
    sort: state.sort,
    folderId: state.folderId,
    tagId: state.tagId,
  );
});

final notesViewModelProvider = Provider<NotesViewModel>((ref) {
  return NotesViewModel(ref.watch(notesRepositoryProvider));
});

class NotesViewModel {
  final NotesRepository _repository;

  NotesViewModel(this._repository);

  Future<void> deleteNote(String id, {bool hardDelete = false}) async {
    await _repository.deleteNote(id, hardDelete: hardDelete);
  }

  Future<void> duplicateNote(String id) async {
    await _repository.duplicateNote(id);
  }

  Future<void> togglePin(Note note) async {
    await _repository.updateNote(note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    ));
  }

  Future<void> toggleFavourite(Note note) async {
    await _repository.updateNote(note.copyWith(
      isFavourite: !note.isFavourite,
      updatedAt: DateTime.now(),
    ));
  }
  
  Future<void> toggleArchive(Note note) async {
    await _repository.updateNote(note.copyWith(
      isArchived: !note.isArchived,
      updatedAt: DateTime.now(),
    ));
  }
}
