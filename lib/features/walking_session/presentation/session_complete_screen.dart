import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import 'providers/session_state.dart';
import 'dart:math' as math;

class SessionCompleteScreen extends ConsumerStatefulWidget {
  const SessionCompleteScreen({super.key});

  @override
  ConsumerState<SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends ConsumerState<SessionCompleteScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start animations
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionProvider);
    final session = sessionState.session;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // Falling petals animation
          const SakuraPetalsAnimation(),

          // Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Success icon
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 80,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Title
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              'Well Done!',
                              style: TextStyle(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              'お疲れ様でした',
                              style: TextStyle(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Session summary
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildSummaryCard(session, isDark),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _returnToDashboard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _shareSession,
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(dynamic session, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryDark.withOpacity(0.1)
            : AppColors.secondaryLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.secondaryDark.withOpacity(0.2)
              : AppColors.secondaryLight.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Total Time',
            session.formattedDuration,
            Icons.schedule,
            isDark,
          ),
          const SizedBox(height: 20),
          _buildSummaryRow(
            'Intervals Completed',
            '${session.completedCycles * 2}',
            Icons.repeat,
            isDark,
          ),
          const SizedBox(height: 20),
          _buildSummaryRow(
            'Cycles',
            '${session.completedCycles}/${session.totalCycles}',
            Icons.refresh,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _returnToDashboard() {
    // Pop all screens and return to dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _shareSession() {
    // Implement share functionality
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// Sakura petals falling animation
class SakuraPetalsAnimation extends StatefulWidget {
  const SakuraPetalsAnimation({super.key});

  @override
  State<SakuraPetalsAnimation> createState() => _SakuraPetalsAnimationState();
}

class _SakuraPetalsAnimationState extends State<SakuraPetalsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Petal> _petals = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Create petals
    for (int i = 0; i < 15; i++) {
      _petals.add(Petal(
        x: _random.nextDouble(),
        startDelay: _random.nextDouble(),
        speed: 0.3 + _random.nextDouble() * 0.4,
        size: 15 + _random.nextDouble() * 15,
        rotation: _random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: PetalsPainter(
            petals: _petals,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Petal {
  final double x;
  final double startDelay;
  final double speed;
  final double size;
  final double rotation;

  Petal({
    required this.x,
    required this.startDelay,
    required this.speed,
    required this.size,
    required this.rotation,
  });
}

class PetalsPainter extends CustomPainter {
  final List<Petal> petals;
  final double progress;

  PetalsPainter({
    required this.petals,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (final petal in petals) {
      final adjustedProgress = ((progress + petal.startDelay) % 1.0);
      final y = adjustedProgress * size.height * petal.speed;

      if (y < size.height) {
        final x = size.width * petal.x + math.sin(y / 50) * 30;

        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(petal.rotation + progress * 2 * math.pi);

        // Draw simple petal shape
        final path = Path();
        path.moveTo(0, 0);
        path.quadraticBezierTo(
          petal.size / 2,
          petal.size / 4,
          petal.size / 2,
          petal.size,
        );
        path.quadraticBezierTo(
          petal.size / 4,
          petal.size * 0.75,
          0,
          petal.size / 2,
        );
        path.quadraticBezierTo(
          -petal.size / 4,
          petal.size * 0.75,
          -petal.size / 2,
          petal.size,
        );
        path.quadraticBezierTo(
          -petal.size / 2,
          petal.size / 4,
          0,
          0,
        );
        path.close();

        canvas.drawPath(path, paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(PetalsPainter oldDelegate) => true;
}
