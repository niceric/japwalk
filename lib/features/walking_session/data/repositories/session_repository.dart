import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/walking_session.dart';

/// Repository for managing walking session persistence
class SessionRepository {
  static const String _boxName = 'sessions';

  Box<WalkingSession> get _box => Hive.box<WalkingSession>(_boxName);

  /// Save a walking session
  Future<void> saveSession(WalkingSession session) async {
    await _box.put(session.id, session);
  }

  /// Get a session by ID
  WalkingSession? getSession(String id) {
    return _box.get(id);
  }

  /// Get all sessions
  List<WalkingSession> getAllSessions() {
    return _box.values.toList();
  }

  /// Get all completed sessions
  List<WalkingSession> getCompletedSessions() {
    return _box.values.where((session) => session.completed).toList();
  }

  /// Get sessions for a specific date
  List<WalkingSession> getSessionsForDate(DateTime date) {
    return _box.values.where((session) {
      final sessionDate = session.startTime;
      return sessionDate.year == date.year &&
          sessionDate.month == date.month &&
          sessionDate.day == date.day;
    }).toList();
  }

  /// Get sessions within a date range
  List<WalkingSession> getSessionsInRange(DateTime start, DateTime end) {
    return _box.values.where((session) {
      return session.startTime.isAfter(start) &&
          session.startTime.isBefore(end);
    }).toList();
  }

  /// Get sessions for the current week
  List<WalkingSession> getWeeklySessions() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return getSessionsInRange(startOfWeek, endOfWeek);
  }

  /// Get sessions for the current month
  List<WalkingSession> getMonthlySessions() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    return getSessionsInRange(startOfMonth, endOfMonth);
  }

  /// Delete a session
  Future<void> deleteSession(String id) async {
    await _box.delete(id);
  }

  /// Delete all sessions
  Future<void> deleteAllSessions() async {
    await _box.clear();
  }

  /// Get total number of completed sessions
  int getTotalCompletedSessions() {
    return getCompletedSessions().length;
  }

  /// Get total time walked in seconds
  int getTotalTimeWalked() {
    return getCompletedSessions().fold(
      0,
      (sum, session) => sum + session.totalDuration,
    );
  }

  /// Get current streak (consecutive days with at least one session)
  int getCurrentStreak() {
    final completedSessions = getCompletedSessions();
    if (completedSessions.isEmpty) return 0;

    // Sort sessions by date (newest first)
    completedSessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if there's a session today or yesterday
    final latestSession = completedSessions.first;
    final latestDate = DateTime(
      latestSession.startTime.year,
      latestSession.startTime.month,
      latestSession.startTime.day,
    );

    final daysDifference = todayDate.difference(latestDate).inDays;

    // If last session was more than 1 day ago, streak is broken
    if (daysDifference > 1) return 0;

    // Count consecutive days
    int streak = 1;
    DateTime currentDate = latestDate;

    for (int i = 1; i < completedSessions.length; i++) {
      final sessionDate = DateTime(
        completedSessions[i].startTime.year,
        completedSessions[i].startTime.month,
        completedSessions[i].startTime.day,
      );

      final difference = currentDate.difference(sessionDate).inDays;

      if (difference == 1) {
        streak++;
        currentDate = sessionDate;
      } else if (difference > 1) {
        break;
      }
      // If difference == 0, it's the same day, skip to next session
    }

    return streak;
  }

  /// Get the longest streak ever
  int getLongestStreak() {
    final completedSessions = getCompletedSessions();
    if (completedSessions.isEmpty) return 0;

    // Sort sessions by date
    completedSessions.sort((a, b) => a.startTime.compareTo(b.startTime));

    int longestStreak = 1;
    int currentStreak = 1;
    DateTime? previousDate;

    for (final session in completedSessions) {
      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      if (previousDate != null) {
        final difference = sessionDate.difference(previousDate).inDays;

        if (difference == 1) {
          currentStreak++;
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
        } else if (difference > 1) {
          currentStreak = 1;
        }
      }

      previousDate = sessionDate;
    }

    return longestStreak;
  }

  /// Get average session duration in seconds
  double getAverageSessionDuration() {
    final completedSessions = getCompletedSessions();
    if (completedSessions.isEmpty) return 0;

    final totalTime = getTotalTimeWalked();
    return totalTime / completedSessions.length;
  }
}

/// Provider for SessionRepository
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository();
});
