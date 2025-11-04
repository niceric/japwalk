import 'package:flutter_vibrate/flutter_vibrate.dart';

class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  bool _isSupported = false;

  // Initialize and check if device supports vibration
  Future<void> initialize() async {
    _isSupported = await Vibrate.canVibrate;
  }

  // Light haptic feedback for button presses
  Future<void> light() async {
    if (!_isSupported) return;
    Vibrate.feedback(FeedbackType.light);
  }

  // Medium haptic feedback for interval changes
  Future<void> medium() async {
    if (!_isSupported) return;
    Vibrate.feedback(FeedbackType.medium);
  }

  // Heavy haptic feedback for session completion
  Future<void> heavy() async {
    if (!_isSupported) return;
    Vibrate.feedback(FeedbackType.heavy);
  }

  // Custom pattern for interval transition
  // Pattern: [wait, vibrate, wait, vibrate]
  Future<void> intervalTransition() async {
    if (!_isSupported) return;
    Vibrate.vibrateWithPauses([
      const Duration(milliseconds: 100),
      const Duration(milliseconds: 200),
      const Duration(milliseconds: 100),
    ]);
  }

  // Pattern for session complete
  Future<void> sessionComplete() async {
    if (!_isSupported) return;
    Vibrate.vibrateWithPauses([
      const Duration(milliseconds: 100),
      const Duration(milliseconds: 100),
      const Duration(milliseconds: 100),
      const Duration(milliseconds: 100),
      const Duration(milliseconds: 200),
    ]);
  }

  // Cancel any ongoing vibration
  Future<void> cancel() async {
    // flutter_vibrate doesn't have a cancel method, but vibrations are short enough
    // that this isn't typically needed. Keeping method for API compatibility.
  }
}
