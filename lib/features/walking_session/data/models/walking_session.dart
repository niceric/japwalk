import 'package:hive/hive.dart';
import 'interval_config.dart';

part 'walking_session.g.dart';

@HiveType(typeId: 1)
class WalkingSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime startTime;

  @HiveField(2)
  final DateTime? endTime;

  @HiveField(3)
  final int fastIntervalDuration; // seconds

  @HiveField(4)
  final int slowIntervalDuration; // seconds

  @HiveField(5)
  final int completedCycles;

  @HiveField(6)
  final int totalCycles;

  @HiveField(7)
  final bool completed;

  @HiveField(8)
  final int? caloriesBurned;

  const WalkingSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.fastIntervalDuration,
    required this.slowIntervalDuration,
    required this.completedCycles,
    required this.totalCycles,
    required this.completed,
    this.caloriesBurned,
  });

  // Create a new session from interval config
  factory WalkingSession.fromConfig(IntervalConfig config) {
    return WalkingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
      fastIntervalDuration: config.fastDuration * 60, // convert to seconds
      slowIntervalDuration: config.slowDuration * 60, // convert to seconds
      completedCycles: 0,
      totalCycles: config.cycles,
      completed: false,
    );
  }

  // Get total session duration in seconds
  int get totalDuration {
    if (endTime != null) {
      return endTime!.difference(startTime).inSeconds;
    }
    return (fastIntervalDuration + slowIntervalDuration) * totalCycles;
  }

  // Get formatted duration string
  String get formattedDuration {
    final duration = Duration(seconds: totalDuration);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Copy with method for updating session state
  WalkingSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? fastIntervalDuration,
    int? slowIntervalDuration,
    int? completedCycles,
    int? totalCycles,
    bool? completed,
    int? caloriesBurned,
  }) {
    return WalkingSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      fastIntervalDuration: fastIntervalDuration ?? this.fastIntervalDuration,
      slowIntervalDuration: slowIntervalDuration ?? this.slowIntervalDuration,
      completedCycles: completedCycles ?? this.completedCycles,
      totalCycles: totalCycles ?? this.totalCycles,
      completed: completed ?? this.completed,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalkingSession &&
        other.id == id &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.fastIntervalDuration == fastIntervalDuration &&
        other.slowIntervalDuration == slowIntervalDuration &&
        other.completedCycles == completedCycles &&
        other.totalCycles == totalCycles &&
        other.completed == completed &&
        other.caloriesBurned == caloriesBurned;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        fastIntervalDuration.hashCode ^
        slowIntervalDuration.hashCode ^
        completedCycles.hashCode ^
        totalCycles.hashCode ^
        completed.hashCode ^
        caloriesBurned.hashCode;
  }

  @override
  String toString() {
    return 'WalkingSession(id: $id, startTime: $startTime, endTime: $endTime, completedCycles: $completedCycles/$totalCycles, completed: $completed)';
  }
}
