import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/providers/repository_providers.dart';
import '../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(settingsProvider);
              return Column(
                children: [
                  // ignore: deprecated_member_use
                  RadioListTile<ThemeMode>(
                    title: const Text('System Default'),
                    value: ThemeMode.system,
                    groupValue: settings.themeMode,
                    onChanged: (val) => ref.read(settingsProvider.notifier).setThemeMode(val!),
                  ),
                  // ignore: deprecated_member_use
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: settings.themeMode,
                    onChanged: (val) => ref.read(settingsProvider.notifier).setThemeMode(val!),
                  ),
                  // ignore: deprecated_member_use
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: settings.themeMode,
                    onChanged: (val) => ref.read(settingsProvider.notifier).setThemeMode(val!),
                  ),
                ],
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(settingsProvider);
              return SwitchListTile(
                title: const Text('Dynamic Color'),
                subtitle: const Text('Use system colors on supported devices'),
                value: settings.dynamicColor,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).setDynamicColor(val);
                },
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Notes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
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
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Data & Storage', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Backup & Restore', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Export Backup'),
            subtitle: const Text('Create a .purenote archive of all your data'),
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
            subtitle: const Text('Import data from a .purenote archive'),
            onTap: () async {
              final result = await FilePicker.pickFiles(
                type: FileType.any, // .purenote is not a standard type
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
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('About', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About PureNote'),
            subtitle: const Text('Open-source info, Privacy Policy, and Licenses'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'PureNote',
                applicationVersion: '1.0.0',
                applicationIcon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.edit_note, size: 64),
                ),
                applicationLegalese: 'A 100% offline, privacy-first Flutter notes app.\nLicensed under GPL-3.0.',
              );
            },
          ),
        ],
      ),
    );
  }
}
