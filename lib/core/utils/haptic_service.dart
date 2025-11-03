import 'package:vibration/vibration.dart';

class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool _isSupported = false;

  // Initialize and check if device supports vibration
  Future<void> initialize() async {
    _isSupported = await Vibration.hasVibrator() ?? false;
  }

  // Light haptic feedback for button presses
  Future<void> light() async {
    if (!_isSupported) return;
    await Vibration.vibrate(duration: 50);
  }

  // Medium haptic feedback for interval changes
  Future<void> medium() async {
    if (!_isSupported) return;
    await Vibration.vibrate(duration: 100);
  }

  // Heavy haptic feedback for session completion
  Future<void> heavy() async {
    if (!_isSupported) return;
    await Vibration.vibrate(duration: 200);
  }

  // Custom pattern for interval transition
  // Pattern: [wait, vibrate, wait, vibrate]
  Future<void> intervalTransition() async {
    if (!_isSupported) return;
    await Vibration.vibrate(
      pattern: [0, 100, 200, 100],
    );
  }

  // Pattern for session complete
  Future<void> sessionComplete() async {
    if (!_isSupported) return;
    await Vibration.vibrate(
      pattern: [0, 100, 100, 100, 100, 200],
    );
  }

  // Cancel any ongoing vibration
  Future<void> cancel() async {
    if (!_isSupported) return;
    await Vibration.cancel();
  }
}
