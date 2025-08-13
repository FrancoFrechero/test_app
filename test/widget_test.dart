import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/main.dart';

void main() {
  testWidgets('Tips tab is accessible from navigation bar', (tester) async {
    await tester.pumpWidget(const StrideClubApp());
    // Default page should show Upcoming Runs
    expect(find.text('Upcoming Runs'), findsOneWidget);

    await tester.tap(find.text('Tips'));
    await tester.pumpAndSettle();

    expect(find.text('Running Tips'), findsOneWidget);
  });
}
