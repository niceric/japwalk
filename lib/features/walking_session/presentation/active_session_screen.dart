import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/audio_service.dart';
import '../../../core/utils/haptic_service.dart';
import 'providers/session_state.dart';
import 'session_complete_screen.dart';
import 'dart:math' as math;

class ActiveSessionScreen extends ConsumerStatefulWidget {
  const ActiveSessionScreen({super.key});

  @override
  ConsumerState<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _audioService = AudioService();
  final _hapticService = HapticService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Initialize services
    _audioService.initialize();
    _hapticService.initialize();

    // Start the session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final config = ref.read(intervalConfigProvider);
      ref.read(sessionProvider.notifier).startSession(config);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for status changes
    ref.listen<SessionState>(sessionProvider, (previous, next) {
      if (previous?.currentIntervalType != next.currentIntervalType) {
        // Interval changed
        _onIntervalChange();
      }

      if (next.status == SessionStatus.completed) {
        // Session completed
        _onSessionComplete();
      }
    });

    if (sessionState.status == SessionStatus.idle) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final intervalColor = sessionState.isFastInterval
        ? AppColors.primary
        : Colors.blue;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with stop button
            _buildTopBar(isDark),

            // Main timer area
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Interval type
                    _buildIntervalLabel(sessionState, isDark),
                    const SizedBox(height: 40),

                    // Circular progress with timer
                    _buildCircularTimer(sessionState, intervalColor, isDark),
                    const SizedBox(height: 40),

                    // Cycle counter
                    _buildCycleCounter(sessionState, isDark),
                  ],
                ),
              ),
            ),

            // Bottom controls
            _buildBottomControls(sessionState, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            onPressed: _showStopDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalLabel(SessionState state, bool isDark) {
    return Column(
      children: [
        Text(
          state.isFastInterval ? '速い' : 'ゆっくり',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          state.isFastInterval ? 'FAST' : 'SLOW',
          style: TextStyle(
            color: state.isFastInterval ? AppColors.primary : Colors.blue,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularTimer(SessionState state, Color color, bool isDark) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: const Size(280, 280),
            painter: CircularProgressPainter(
              progress: 1.0,
              color: color.withOpacity(0.1),
              strokeWidth: 12,
            ),
          ),
          // Progress circle
          CustomPaint(
            size: const Size(280, 280),
            painter: CircularProgressPainter(
              progress: state.progress,
              color: color,
              strokeWidth: 12,
            ),
          ),
          // Timer text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ref.read(sessionProvider.notifier).getFormattedTime(),
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'remaining',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCycleCounter(SessionState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryDark.withOpacity(0.1)
            : AppColors.secondaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Cycle ${state.currentCycle} of ${state.session?.totalCycles ?? 0}',
        style: TextStyle(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBottomControls(SessionState state, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
          onPressed: _togglePause,
          child: Icon(
            state.status == SessionStatus.paused ? Icons.play_arrow : Icons.pause,
            size: 40,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  void _togglePause() {
    final sessionNotifier = ref.read(sessionProvider.notifier);
    final state = ref.read(sessionProvider);

    if (state.status == SessionStatus.running) {
      sessionNotifier.pauseSession();
      _hapticService.light();
    } else if (state.status == SessionStatus.paused) {
      sessionNotifier.resumeSession();
      _hapticService.light();
    }
  }

  void _showStopDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Walking?'),
        content: const Text('Are you sure you want to stop your walking session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(sessionProvider.notifier).stopSession();
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close session screen
            },
            child: const Text(
              'Stop',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _onIntervalChange() {
    _hapticService.intervalTransition();
    _audioService.playIntervalChange();
    _animationController.forward(from: 0);
  }

  void _onSessionComplete() {
    _hapticService.sessionComplete();
    _audioService.playSessionComplete();

    // Navigate to completion screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SessionCompleteScreen(),
      ),
    );
  }
}

// Custom painter for circular progress
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw arc from top (270 degrees) clockwise
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Sweep angle based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
