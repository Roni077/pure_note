import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../domain/repositories/notes_repository.dart';
import '../../../../data/providers/repository_providers.dart';

final trashListProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(notesRepositoryProvider);
  return repo.watchNotes(filter: NoteFilter.deleted);
});

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashAsync = ref.watch(trashListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Empty Trash',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Empty Trash'),
                  content: const Text('Are you sure you want to permanently delete all notes in the trash?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        // We need a repository method to empty trash.
                        // Or we can just iterate the list.
                        final currentNotes = trashAsync.value ?? [];
                        for (final note in currentNotes) {
                           ref.read(notesRepositoryProvider).deleteNote(note.id, hardDelete: true);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('Empty'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: trashAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.delete_outline,
              title: 'Trash is empty',
              message: 'No deleted notes here.',
            );
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title.isNotEmpty ? note.title : 'Untitled'),
                subtitle: Text('Deleted on ${note.updatedAt.toLocal().toString().split(' ')[0]}'),
                onTap: () => _showOptions(context, ref, note),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.restore),
                      tooltip: 'Restore',
                      onPressed: () {
                        ref.read(notesRepositoryProvider).updateNote(note.copyWith(isDeleted: false));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      tooltip: 'Delete Permanently',
                      onPressed: () {
                        ref.read(notesRepositoryProvider).deleteNote(note.id, hardDelete: true);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref, note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trash Options'),
        content: const Text('Would you like to restore this note or delete it permanently?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(notesRepositoryProvider).updateNote(note.copyWith(isDeleted: false));
              Navigator.pop(context);
            },
            child: const Text('Restore'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(notesRepositoryProvider).deleteNote(note.id, hardDelete: true);
              Navigator.pop(context);
            },
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }
}
