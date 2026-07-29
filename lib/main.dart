import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'ui/features/settings/viewmodels/settings_viewmodel.dart';
import 'data/providers/repository_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  final settings = container.read(settingsProvider);
  if (settings.autoEmptyTrashDays > 0) {
    // Run trash cleanup in the background
    container.read(notesRepositoryProvider).cleanUpTrash(settings.autoEmptyTrashDays);
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PureNoteApp(),
    ),
  );
}

class PureNoteApp extends ConsumerWidget {
  const PureNoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider).themeMode;
    
    return MaterialApp.router(
      title: 'PureNote',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
