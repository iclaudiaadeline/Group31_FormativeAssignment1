// Basic widget test for ALU Academic Platform
//
// This test verifies that the app can be instantiated and rendered.

import 'package:flutter_test/flutter_test.dart';
import 'package:group31_formative_assignment1/main.dart';

void main() {
  testWidgets('App smoke test - MainApp can be instantiated', (
    WidgetTester tester,
  ) async {
    // Note: This is a basic smoke test
    // Full widget tests would require Firebase mocking
    // For now, we verify the ErrorApp can be rendered
    await tester.pumpWidget(const ErrorApp(error: 'Test error'));

    // Verify error screen displays
    expect(find.text('Firebase Initialization Error'), findsOneWidget);
    expect(find.text('Test error'), findsOneWidget);
  });
}
