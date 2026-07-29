import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/folders_viewmodel.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../notes/viewmodels/notes_viewmodel.dart';

class FoldersScreen extends ConsumerWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
      ),
      body: foldersAsync.when(
        data: (folders) {
          if (folders.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.folder_open,
              title: 'No Folders',
              message: 'Organize your notes into folders.',
            );
          }
          return ListView.builder(
            itemCount: folders.length,
            itemBuilder: (context, index) {
              final folder = folders[index];
              return ListTile(
                leading: const Icon(Icons.folder, color: Colors.blue),
                title: Text(folder.name),
                onTap: () {
                  ref.read(notesFilterProvider.notifier).update((state) => state.copyWith(folderId: folder.id));
                  context.go('/'); // go back to notes tab
                },
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'delete') {
                      ref.read(foldersViewModelProvider).deleteFolder(folder.id);
                      final currentFilter = ref.read(notesFilterProvider).folderId;
                      if (currentFilter == folder.id) {
                         ref.read(notesFilterProvider.notifier).update((state) => state.copyWith(folderId: null));
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFolderDialog(context, ref),
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }

  void _showFolderDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Folder Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(foldersViewModelProvider).createFolder(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
