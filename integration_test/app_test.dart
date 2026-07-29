import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pure_note/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App start and navigate to editor smoke test', (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    // Verify we are on the Onboarding or Notes List screen.
    // Since it's a fresh install in test, it likely hits Onboarding.
    expect(find.text('PureNote'), findsWidgets);
    
    // Tap 'Get Started' if we are on Onboarding
    final getStartedButton = find.text('Get Started');
    if (getStartedButton.evaluate().isNotEmpty) {
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();
    }

    // Now we should be on the Notes List
    expect(find.text('No notes found.'), findsOneWidget);
  });
}
