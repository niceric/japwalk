import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/interval_config.dart';
import '../../data/models/walking_session.dart';
import '../../data/repositories/session_repository.dart';

// Enum for interval type
enum IntervalType { fast, slow }

// Enum for session status
enum SessionStatus { idle, running, paused, completed }

// Session state class
class SessionState {
  final WalkingSession? session;
  final SessionStatus status;
  final IntervalType currentIntervalType;
  final int currentCycle;
  final int remainingSeconds;
  final int totalIntervalSeconds;

  const SessionState({
    this.session,
    required this.status,
    required this.currentIntervalType,
    required this.currentCycle,
    required this.remainingSeconds,
    required this.totalIntervalSeconds,
  });

  factory SessionState.initial() {
    return const SessionState(
      session: null,
      status: SessionStatus.idle,
      currentIntervalType: IntervalType.fast,
      currentCycle: 0,
      remainingSeconds: 0,
      totalIntervalSeconds: 0,
    );
  }

  double get progress {
    if (totalIntervalSeconds == 0) return 0;
    return (totalIntervalSeconds - remainingSeconds) / totalIntervalSeconds;
  }

  bool get isFastInterval => currentIntervalType == IntervalType.fast;

  SessionState copyWith({
    WalkingSession? session,
    SessionStatus? status,
    IntervalType? currentIntervalType,
    int? currentCycle,
    int? remainingSeconds,
    int? totalIntervalSeconds,
  }) {
    return SessionState(
      session: session ?? this.session,
      status: status ?? this.status,
      currentIntervalType: currentIntervalType ?? this.currentIntervalType,
      currentCycle: currentCycle ?? this.currentCycle,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalIntervalSeconds: totalIntervalSeconds ?? this.totalIntervalSeconds,
    );
  }
}

// Session notifier
class SessionNotifier extends StateNotifier<SessionState> {
  Timer? _timer;
  final void Function()? onIntervalChange;
  final void Function()? onSessionComplete;
  final SessionRepository _repository;

  SessionNotifier(
    this._repository, {
    this.onIntervalChange,
    this.onSessionComplete,
  }) : super(SessionState.initial());

  // Start a new session
  void startSession(IntervalConfig config) {
    final session = WalkingSession.fromConfig(config);
    state = SessionState(
      session: session,
      status: SessionStatus.running,
      currentIntervalType: IntervalType.fast,
      currentCycle: 1,
      remainingSeconds: session.fastIntervalDuration,
      totalIntervalSeconds: session.fastIntervalDuration,
    );
    _startTimer();
  }

  // Start the countdown timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      } else {
        _handleIntervalComplete();
      }
    });
  }

  // Handle interval completion
  void _handleIntervalComplete() {
    final session = state.session;
    if (session == null) return;

    // Notify about interval change
    onIntervalChange?.call();

    // Check if we're at the end of a cycle (completed both fast and slow)
    if (state.currentIntervalType == IntervalType.slow) {
      // Cycle complete
      final newCycle = state.currentCycle + 1;

      if (newCycle > session.totalCycles) {
        // Session complete!
        _completeSession();
        return;
      }

      // Start next cycle with fast interval
      state = state.copyWith(
        currentIntervalType: IntervalType.fast,
        currentCycle: newCycle,
        remainingSeconds: session.fastIntervalDuration,
        totalIntervalSeconds: session.fastIntervalDuration,
      );
    } else {
      // Switch from fast to slow interval
      state = state.copyWith(
        currentIntervalType: IntervalType.slow,
        remainingSeconds: session.slowIntervalDuration,
        totalIntervalSeconds: session.slowIntervalDuration,
      );
    }
  }

  // Complete the session
  void _completeSession() async {
    _timer?.cancel();
    final session = state.session;
    if (session != null) {
      final completedSession = session.copyWith(
        endTime: DateTime.now(),
        completedCycles: session.totalCycles,
        completed: true,
      );

      // Save the completed session to the database
      await _repository.saveSession(completedSession);

      state = state.copyWith(
        session: completedSession,
        status: SessionStatus.completed,
        remainingSeconds: 0,
      );
      onSessionComplete?.call();
    }
  }

  // Pause the session
  void pauseSession() {
    if (state.status == SessionStatus.running) {
      _timer?.cancel();
      state = state.copyWith(status: SessionStatus.paused);
    }
  }

  // Resume the session
  void resumeSession() {
    if (state.status == SessionStatus.paused) {
      state = state.copyWith(status: SessionStatus.running);
      _startTimer();
    }
  }

  // Stop the session
  void stopSession() {
    _timer?.cancel();
    state = SessionState.initial();
  }

  // Format remaining time as MM:SS
  String getFormattedTime() {
    final minutes = state.remainingSeconds ~/ 60;
    final seconds = state.remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Provider for session state
final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return SessionNotifier(repository);
});

// Provider for interval configuration
final intervalConfigProvider = StateProvider<IntervalConfig>((ref) {
  return IntervalConfig.defaultConfig();
});
