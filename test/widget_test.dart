import 'package:flutter_test/flutter_test.dart';
import 'package:homework_tracker/main.dart';

void main() {
  testWidgets('Homework Tracker app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeworkTrackerApp());

    // Check that the splash screen appears.
    expect(find.text('Homework Tracker'), findsOneWidget);

    // Advance the fake clock past the 3-second splash timer.
    await tester.pump(const Duration(seconds: 3));

    // Finish any animations or scheduled frames.
    await tester.pumpAndSettle();
  });
}
