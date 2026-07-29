import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});
  
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (MediaQuery.sizeOf(context).width > 600)
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.note),
                  label: Text('Notes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.folder),
                  label: Text('Folders'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.label),
                  label: Text('Tags'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.delete),
                  label: Text('Trash'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width <= 600
          ? NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.note), label: 'Notes'),
                NavigationDestination(icon: Icon(Icons.folder), label: 'Folders'),
                NavigationDestination(icon: Icon(Icons.label), label: 'Tags'),
                NavigationDestination(icon: Icon(Icons.delete), label: 'Trash'),
                NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            )
          : null,
    );
  }
}
