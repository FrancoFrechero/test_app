import 'dart:async';

import 'models.dart';

class ReminderService {
  final Map<String, Timer> _timers = {};

  void scheduleRunReminder(Run run) {
    final now = DateTime.now();
    final dayStart = DateTime(run.dateTime.year, run.dateTime.month, run.dateTime.day, 8);
    final duration = dayStart.difference(now);
    if (duration.isNegative) return;
    _timers[run.id]?.cancel();
    _timers[run.id] = Timer(duration, () {
      print('Reminder: ${run.title} today at ${run.timeLabel}');
    });
  }

  void cancel(String runId) {
    _timers.remove(runId)?.cancel();
  }
}
