import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/providers/repository_providers.dart';
import '../viewmodels/settings_viewmodel.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  Future<bool> _authenticate(BuildContext context, WidgetRef ref, String reason) async {
    final authService = ref.read(authServiceProvider);
    return await authService.authenticate(reason);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Authentication', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ),
          Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(settingsProvider);
              return Column(
                children: [
                  SwitchListTile(
                    title: const Text('App Lock'),
                    subtitle: const Text('Require authentication to open the app'),
                    value: settings.enableAppLock,
                    onChanged: (val) async {
                      if (val) {
                        final auth = await _authenticate(context, ref, 'Authenticate to enable App Lock');
                        if (auth) {
                          ref.read(settingsProvider.notifier).setEnableAppLock(val);
                        }
                      } else {
                        final auth = await _authenticate(context, ref, 'Authenticate to disable App Lock');
                        if (auth) {
                          ref.read(settingsProvider.notifier).setEnableAppLock(val);
                        }
                      }
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Hide Locked Notes Preview'),
                    subtitle: const Text('Blur the preview content of locked notes'),
                    value: settings.hideLockedNotesPreview,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).setHideLockedNotesPreview(val);
                    },
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
