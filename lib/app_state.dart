import 'package:flutter/material.dart';
import 'models.dart';
import 'reminder_service.dart';

class RunClubState extends ChangeNotifier {
  final ReminderService reminderService;
  RunClubState(this.reminderService)
      : runs = [...demoRuns],
        currentUser = const User('You');

  final List<Run> runs;
  User currentUser;

  bool get isCoach => currentUser.isCoach;

  void signInAsCoach(String name, String password) {
    if (password == 'coach123') {
      currentUser = User(name, isCoach: true);
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  bool isJoined(Run run) {
    return run.participants.any((p) => p.name == currentUser.name);
  }

  void toggleJoin(Run run) {
    if (isJoined(run)) {
      run.participants.removeWhere((p) => p.name == currentUser.name);
      reminderService.cancel(run.id);
    } else {
      run.participants.add(currentUser);
      reminderService.scheduleRunReminder(run);
    }
    notifyListeners();
  }

  void createRun({
    required String title,
    required String city,
    required String location,
    required double distanceKm,
    required String paceMinPerKm,
    required DateTime dateTime,
  }) {
    final run = Run(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      city: city,
      location: location,
      distanceKm: distanceKm,
      paceMinPerKm: paceMinPerKm,
      dateTime: dateTime,
      participants: [],
    );
    runs.add(run);
    notifyListeners();
  }
}
