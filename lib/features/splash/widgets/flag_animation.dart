import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Animated Japanese flag widget with ripple effect
class FlagAnimation extends StatefulWidget {
  final double size;
  final bool isDark;

  const FlagAnimation({
    super.key,
    required this.size,
    this.isDark = false,
  });

  @override
  State<FlagAnimation> createState() => _FlagAnimationState();
}

class _FlagAnimationState extends State<FlagAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _setupRippleAnimation();
  }

  void _setupRippleAnimation() {
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Curves.easeOut,
      ),
    );

    // Start ripple animation after a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _rippleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDark 
        ? AppColors.darkBackground 
        : AppColors.lightBackground;
    final circleColor = widget.isDark 
        ? AppColors.darkPrimary 
        : AppColors.lightPrimary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple effect
          AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (context, child) {
              return Container(
                width: widget.size * _rippleAnimation.value,
                height: widget.size * _rippleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: circleColor.withOpacity(
                      0.3 * (1 - _rippleAnimation.value),
                    ),
                    width: 3,
                  ),
                ),
              );
            },
          ),
          // Background (white rectangle simulating flag)
          Container(
            width: widget.size,
            height: widget.size * 0.67, // Japanese flag ratio (2:3)
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          // Red circle (sun)
          Container(
            width: widget.size * 0.4,
            height: widget.size * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
              boxShadow: [
                BoxShadow(
                  color: circleColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
