import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pure_note/domain/models/note_model.dart';
import 'package:pure_note/core/widgets/empty_state_widget.dart';
import 'package:pure_note/core/widgets/adaptive_note_layout.dart';
import 'package:pure_note/ui/features/notes/viewmodels/notes_viewmodel.dart';
import 'package:pure_note/domain/repositories/notes_repository.dart';
import '../../../../data/providers/repository_providers.dart';

class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  Future<void> _importNote(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'json', 'md'],
    );
    
    if (result != null && result.files.single.path != null) {
      if (!context.mounted) return;
      try {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        final ext = result.files.single.extension?.toLowerCase();
        final title = result.files.single.name.replaceAll(RegExp(r'\.[^.]+$'), '');
        
        String deltaJson;
        if (ext == 'json') {
           deltaJson = content;
        } else {
           final escapedText = jsonEncode('$content\n');
           deltaJson = '[{"insert":$escapedText}]';
        }
        
        final newNote = Note(
           id: const Uuid().v4(),
           title: title,
           content: deltaJson,
           createdAt: DateTime.now(),
           updatedAt: DateTime.now(),
           tags: [],
        );
        
        await ref.read(notesRepositoryProvider).createNote(newNote);
        
        if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note imported successfully!')));
        }
      } catch (e) {
         if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to import note: $e')));
         }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesListProvider);
    final filterState = ref.watch(notesFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PureNote'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Import Note',
            onPressed: () => _importNote(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: Icon(filterState.isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              ref.read(notesFilterProvider.notifier).update(
                (state) => state.copyWith(isGridView: !state.isGridView),
              );
            },
          ),
          PopupMenuButton<NoteFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (filter) {
              ref.read(notesFilterProvider.notifier).update((state) => state.copyWith(filter: filter));
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: NoteFilter.all, child: Text('All Notes')),
              PopupMenuItem(value: NoteFilter.pinned, child: Text('Pinned')),
              PopupMenuItem(value: NoteFilter.favourite, child: Text('Favourites')),
              PopupMenuItem(value: NoteFilter.archived, child: Text('Archived')),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8.0,
            children: [
              if (filterState.filter != NoteFilter.all)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: InputChip(
                    label: Text('Filtered by ${filterState.filter.name}'),
                    onDeleted: () {
                      ref.read(notesFilterProvider.notifier).update(
                        (state) => state.copyWith(filter: NoteFilter.all),
                      );
                    },
                  ),
                ),
              if (filterState.folderId != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: InputChip(
                    label: const Text('Filtered by Folder'),
                    onDeleted: () {
                      ref.read(notesFilterProvider.notifier).update(
                        (state) => state.copyWith(folderId: null),
                      );
                    },
                  ),
                ),
              if (filterState.tagId != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: InputChip(
                    label: const Text('Filtered by Tag'),
                    onDeleted: () {
                      ref.read(notesFilterProvider.notifier).update(
                        (state) => state.copyWith(tagId: null),
                      );
                    },
                  ),
                ),
            ],
          ),
          Expanded(
            child: notesAsync.when(
              data: (notes) {
                if (notes.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.note_alt_outlined,
                    title: 'No notes yet',
                    message: 'Create your first note and keep your ideas close.',
                  );
                }
                
                return AdaptiveNoteLayout(
            isGridView: filterState.isGridView,
            itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return InkWell(
                    onTap: () async {
                      if (note.isLocked) {
                        final authenticated = await ref.read(authServiceProvider).authenticate('Please authenticate to view this locked note');
                        if (!authenticated) return;
                      }
                      if (context.mounted) {
                        context.push('/editor?id=${note.id}');
                      }
                    },
                    child: Hero(
                      tag: 'note-hero-${note.id}',
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Semantics(
                            label: note.isLocked ? 'Locked Note' : 'Note: ${note.title.isEmpty ? 'Untitled' : note.title}',
                            value: note.isLocked ? '' : note.content,
                            excludeSemantics: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (note.isLocked) ...[
                                  Row(
                                    children: [
                                      const Icon(Icons.lock, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text('Locked Note', style: Theme.of(context).textTheme.titleMedium),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  Text(
                                    note.title.isEmpty ? 'Untitled' : note.title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: Text(
                                      // We shouldn't show raw json directly, but for now it proves it works.
                                      note.content,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
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
    ),
  ],
),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/editor');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
