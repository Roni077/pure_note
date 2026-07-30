import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/settings_viewmodel.dart';

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Theme', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(settingsProvider);
              return Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('System Default'),
                    value: ThemeMode.system,
                    groupValue: settings.themeMode,
                    onChanged: (val) => ref.read(settingsProvider.notifier).setThemeMode(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: settings.themeMode,
                    onChanged: (val) => ref.read(settingsProvider.notifier).setThemeMode(val!),
                  ),
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
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Colors', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
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
        ],
      ),
    );
  }
}
