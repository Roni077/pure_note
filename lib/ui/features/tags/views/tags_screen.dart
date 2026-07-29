import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/tags_viewmodel.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../notes/viewmodels/notes_viewmodel.dart';

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: tagsAsync.when(
        data: (tags) {
          if (tags.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.label_outline,
              title: 'No Tags',
              message: 'Create tags to easily categorize notes.',
            );
          }
          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return ListTile(
                leading: const Icon(Icons.label, color: Colors.blueGrey),
                title: Text(tag.name),
                onTap: () {
                  ref.read(notesFilterProvider.notifier).update((state) => state.copyWith(tagId: tag.id));
                  context.go('/'); 
                },
                trailing: PopupMenuButton<String>(
                  onSelected: (val) {
                    if (val == 'delete') {
                      ref.read(tagsViewModelProvider).deleteTag(tag.id);
                      final currentFilter = ref.read(notesFilterProvider).tagId;
                      if (currentFilter == tag.id) {
                         ref.read(notesFilterProvider.notifier).update((state) => state.copyWith(tagId: null));
                      }
                    }
                  },
                  itemBuilder: (context) => [
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
        onPressed: () => _showTagDialog(context, ref),
        child: const Icon(Icons.new_label),
      ),
    );
  }

  void _showTagDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Tag Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(tagsViewModelProvider).createTag(controller.text.trim());
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
