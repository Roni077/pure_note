import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/search_viewmodel.dart';
import '../../../../core/widgets/adaptive_note_layout.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search notes...',
            border: InputBorder.none,
          ),
          onChanged: (value) => ref.read(searchProvider.notifier).search(value),
        ),
      ),
      body: searchState.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.search,
              title: 'No results',
              message: 'Try a different search term.',
            );
          }
          return AdaptiveNoteLayout(
            isGridView: true,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return InkWell(
                onTap: () => context.push('/editor?id=${note.id}'),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title.isEmpty ? 'Untitled' : note.title,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            note.content,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
