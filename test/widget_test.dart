import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:test_app/main.dart';
import 'package:test_app/app_state.dart';
import 'package:test_app/reminder_service.dart';

void main() {
  testWidgets('shows upcoming runs', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => RunClubState(ReminderService()),
        child: const RunClubApp(),
      ),
    );

    expect(find.text('Upcoming Runs'), findsOneWidget);
  });
}
