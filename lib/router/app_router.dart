import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/features/shell/app_shell.dart';
import '../ui/features/onboarding/views/onboarding_screen.dart';
import '../ui/features/notes/views/notes_list_screen.dart';
import '../ui/features/notes/views/note_editor_screen.dart';
import '../ui/features/search/views/search_screen.dart';
import '../ui/features/folders/views/folders_screen.dart';
import '../ui/features/tags/views/tags_screen.dart';
import '../ui/features/trash/views/trash_screen.dart';
import '../ui/features/settings/views/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildAppRouter(bool showOnboarding) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: showOnboarding ? '/onboarding' : '/',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const NotesListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/folders',
                builder: (context, state) => const FoldersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tags',
                builder: (context, state) => const TagsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trash',
                builder: (context, state) => const TrashScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/editor',
        builder: (context, state) {
          final noteId = state.uri.queryParameters['id'];
          return NoteEditorScreen(noteId: noteId);
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );
}
