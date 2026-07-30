import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Appearance'),
            subtitle: const Text('Theme, colors, and styling'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/appearance'),
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_outlined),
            title: const Text('Notes'),
            subtitle: const Text('Sort order and preview length'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/notes'),
          ),
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: const Text('Data & Storage'),
            subtitle: const Text('Trash, export, and restore backups'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/data'),
          ),
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('Security'),
            subtitle: const Text('App lock and note authentication'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/security'),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('About', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
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
