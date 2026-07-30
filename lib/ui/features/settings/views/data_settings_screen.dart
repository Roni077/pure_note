import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/providers/repository_providers.dart';
import '../viewmodels/settings_viewmodel.dart';

class DataSettingsScreen extends ConsumerWidget {
  const DataSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data & Storage'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Trash', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(settingsProvider);
              return ListTile(
                title: const Text('Auto-empty Trash'),
                subtitle: Text(settings.autoEmptyTrashDays == 0 ? 'Never' : 'After ${settings.autoEmptyTrashDays} days'),
                trailing: DropdownButton<int>(
                  value: settings.autoEmptyTrashDays,
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(settingsProvider.notifier).setAutoEmptyTrashDays(val);
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Never')),
                    DropdownMenuItem(value: 7, child: Text('7 days')),
                    DropdownMenuItem(value: 30, child: Text('30 days')),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Backup & Restore', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Export Backup'),
            subtitle: const Text('Create a .json backup of all your data'),
            onTap: () async {
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Generating backup...')),
                );
                final path = await ref.read(backupServiceProvider).createBackup();
                await SharePlus.instance.share(ShareParams(files: [XFile(path)], subject: 'PureNote Backup'));
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Backup failed: $e')),
                  );
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Backup'),
            subtitle: const Text('Import data from a .json backup'),
            onTap: () async {
              final result = await FilePicker.pickFiles(
                type: FileType.any,
              );
              if (result != null && result.files.single.path != null) {
                if (!context.mounted) return;
                try {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Restoring backup...')),
                  );
                  await ref.read(backupServiceProvider).restoreBackup(result.files.single.path!);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Backup restored successfully!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Restore failed: $e')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
