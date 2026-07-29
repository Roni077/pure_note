// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pure_note/ui/features/settings/viewmodels/settings_viewmodel.dart';

import 'package:pure_note/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Initialize mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PureNoteApp(),
    ));

    // Wait for initial routing to settle
    await tester.pumpAndSettle();

    // Verify that the Onboarding screen is shown initially.
    expect(find.text('PureNote'), findsWidgets);
  });
}
