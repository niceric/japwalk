import 'package:flutter/services.dart';

class HapticService {
  static final HapticService _instance = HapticService._internal();
  factory HapticService() => _instance;
  HapticService._internal();

  // Initialize - no setup needed for native Flutter haptics
  Future<void> initialize() async {
    // Native Flutter haptics don't require initialization
  }

  // Light haptic feedback for button presses
  Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  // Medium haptic feedback for interval changes
  Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  // Heavy haptic feedback for session completion
  Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  // Custom pattern for interval transition
  // Using selection click for a distinctive feel
  Future<void> intervalTransition() async {
    await HapticFeedback.selectionClick();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.selectionClick();
  }

  // Pattern for session complete
  Future<void> sessionComplete() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  // Cancel any ongoing vibration
  Future<void> cancel() async {
    // Native haptics are instantaneous and don't need cancellation
  }
}
