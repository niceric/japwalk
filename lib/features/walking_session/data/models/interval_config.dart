import 'package:hive/hive.dart';

part 'interval_config.g.dart';

@HiveType(typeId: 0)
class IntervalConfig {
  @HiveField(0)
  final int fastDuration; // minutes

  @HiveField(1)
  final int slowDuration; // minutes

  @HiveField(2)
  final int cycles;

  @HiveField(3)
  final bool voiceGuidance;

  @HiveField(4)
  final bool musicIntegration;

  const IntervalConfig({
    required this.fastDuration,
    required this.slowDuration,
    required this.cycles,
    this.voiceGuidance = false,
    this.musicIntegration = false,
  });

  // Default configuration
  factory IntervalConfig.defaultConfig() {
    return const IntervalConfig(
      fastDuration: 3,
      slowDuration: 3,
      cycles: 5,
      voiceGuidance: false,
      musicIntegration: false,
    );
  }

  // Calculate total session duration in minutes
  int get totalDuration => (fastDuration + slowDuration) * cycles;

  // Copy with method for easy modifications
  IntervalConfig copyWith({
    int? fastDuration,
    int? slowDuration,
    int? cycles,
    bool? voiceGuidance,
    bool? musicIntegration,
  }) {
    return IntervalConfig(
      fastDuration: fastDuration ?? this.fastDuration,
      slowDuration: slowDuration ?? this.slowDuration,
      cycles: cycles ?? this.cycles,
      voiceGuidance: voiceGuidance ?? this.voiceGuidance,
      musicIntegration: musicIntegration ?? this.musicIntegration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IntervalConfig &&
        other.fastDuration == fastDuration &&
        other.slowDuration == slowDuration &&
        other.cycles == cycles &&
        other.voiceGuidance == voiceGuidance &&
        other.musicIntegration == musicIntegration;
  }

  @override
  int get hashCode {
    return fastDuration.hashCode ^
        slowDuration.hashCode ^
        cycles.hashCode ^
        voiceGuidance.hashCode ^
        musicIntegration.hashCode;
  }

  @override
  String toString() {
    return 'IntervalConfig(fastDuration: $fastDuration, slowDuration: $slowDuration, cycles: $cycles, voiceGuidance: $voiceGuidance, musicIntegration: $musicIntegration)';
  }
}
