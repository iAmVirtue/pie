import '../models/habit_event.dart';

class HabitDetector {
  static List<String> findHabits(List<HabitEvent> events) {
    // Group events by name
    final Map<String, List<HabitEvent>> grouped = {};
    for (final e in events) {
      grouped.putIfAbsent(e.name.toLowerCase(), () => []).add(e);
    }

    final List<String> habits = [];

    grouped.forEach((name, list) {
      // Group by hour of day (ignoring date)
      final Map<int, int> hourCount = {};
      for (final e in list) {
        final hour = e.timestamp.hour;
        hourCount[hour] = (hourCount[hour] ?? 0) + 1;
      }

      // If any hour has >= 3 occurrences → mark as habit
      if (hourCount.values.any((count) => count >= 3)) {
        habits.add(name);
      }
    });

    return habits;
  }
}
