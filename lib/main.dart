import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'ui/features/settings/viewmodels/settings_viewmodel.dart';
import 'data/providers/repository_providers.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:go_router/go_router.dart';

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

  final bool showOnboarding = !(prefs.getBool('onboarding_completed') ?? false);
  final router = buildAppRouter(showOnboarding);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: PureNoteApp(router: router),
    ),
  );
}

class PureNoteApp extends ConsumerWidget {
  final GoRouter router;
  
  const PureNoteApp({super.key, required this.router});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider).themeMode;
    
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp.router(
          title: 'PureNote',
          theme: AppTheme.getLightTheme(lightDynamic),
          darkTheme: AppTheme.getDarkTheme(darkDynamic),
          themeMode: themeMode,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
