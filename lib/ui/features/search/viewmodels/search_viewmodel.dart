import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/note_model.dart';
import '../../../../data/providers/repository_providers.dart';
import 'dart:async';

final searchProvider = StateNotifierProvider.autoDispose<SearchViewModel, AsyncValue<List<Note>>>((ref) {
  return SearchViewModel(ref);
});

class SearchViewModel extends StateNotifier<AsyncValue<List<Note>>> {
  final Ref _ref;
  Timer? _debounce;
  String _currentQuery = '';

  SearchViewModel(this._ref) : super(const AsyncValue.data([]));

  void search(String query) {
    _currentQuery = query;
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      _debounce?.cancel();
      return;
    }

    state = const AsyncValue.loading();

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final repo = _ref.read(notesRepositoryProvider);
        final results = await repo.searchNotes(_currentQuery);
        state = AsyncValue.data(results);
      } catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
