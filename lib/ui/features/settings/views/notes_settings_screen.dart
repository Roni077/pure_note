import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/settings_viewmodel.dart';

class NotesSettingsScreen extends ConsumerWidget {
  const NotesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Display Options', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(settingsProvider);
              return Column(
                children: [
                  ListTile(
                    title: const Text('Default Sort Order'),
                    trailing: DropdownButton<String>(
                      value: settings.defaultSortOrder,
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(settingsProvider.notifier).setDefaultSortOrder(val);
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: 'updated_desc', child: Text('Recently Updated')),
                        DropdownMenuItem(value: 'created_desc', child: Text('Recently Created')),
                        DropdownMenuItem(value: 'alpha_asc', child: Text('A-Z')),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Preview Lines Length'),
                    trailing: DropdownButton<int>(
                      value: settings.previewLength,
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(settingsProvider.notifier).setPreviewLength(val);
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: 3, child: Text('3 lines')),
                        DropdownMenuItem(value: 5, child: Text('5 lines')),
                        DropdownMenuItem(value: 10, child: Text('10 lines')),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
