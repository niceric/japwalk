import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../data/models/interval_config.dart';
import 'providers/session_state.dart';
import 'active_session_screen.dart';

class PreWalkSetupScreen extends ConsumerStatefulWidget {
  const PreWalkSetupScreen({super.key});

  @override
  ConsumerState<PreWalkSetupScreen> createState() => _PreWalkSetupScreenState();
}

class _PreWalkSetupScreenState extends ConsumerState<PreWalkSetupScreen> {
  int _fastDuration = 3;
  int _slowDuration = 3;
  int _cycles = 5;
  bool _voiceGuidance = false;
  bool _musicIntegration = false;

  int get _totalMinutes => (_fastDuration + _slowDuration) * _cycles;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Setup Walk',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total time display
                    _buildTotalTimeCard(isDark),
                    const SizedBox(height: 32),

                    // Fast interval slider
                    _buildIntervalSlider(
                      'Fast Interval',
                      '速い (Hayai)',
                      _fastDuration,
                      AppColors.primary,
                      (value) => setState(() => _fastDuration = value.round()),
                      isDark,
                    ),
                    const SizedBox(height: 24),

                    // Slow interval slider
                    _buildIntervalSlider(
                      'Slow Interval',
                      'ゆっくり (Yukkuri)',
                      _slowDuration,
                      Colors.blue,
                      (value) => setState(() => _slowDuration = value.round()),
                      isDark,
                    ),
                    const SizedBox(height: 24),

                    // Cycles slider
                    _buildCyclesSlider(isDark),
                    const SizedBox(height: 32),

                    // Options
                    _buildOption(
                      'Voice Guidance',
                      'Audio announcements for intervals',
                      _voiceGuidance,
                      (value) => setState(() => _voiceGuidance = value),
                      isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildOption(
                      'Music Integration',
                      'Control music during walking',
                      _musicIntegration,
                      (value) => setState(() => _musicIntegration = value),
                      isDark,
                    ),
                  ],
                ),
              ),
            ),

            // Start button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _startWalking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Walking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalTimeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Duration',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_totalMinutes minutes',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(
            Icons.schedule,
            size: 48,
            color: AppColors.primary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalSlider(
    String title,
    String subtitle,
    int value,
    Color color,
    ValueChanged<double> onChanged,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: color,
                  inactiveTrackColor: color.withOpacity(0.2),
                  thumbColor: color,
                  overlayColor: color.withOpacity(0.2),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: value.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: onChanged,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$value min',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCyclesSlider(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Number of Cycles',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Fast + Slow = 1 cycle',
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.accent,
                  inactiveTrackColor: AppColors.accent.withOpacity(0.2),
                  thumbColor: AppColors.accent,
                  overlayColor: AppColors.accent.withOpacity(0.2),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: _cycles.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) => setState(() => _cycles = value.round()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$_cycles',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryDark.withOpacity(0.1)
            : AppColors.secondaryLight.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _startWalking() {
    final config = IntervalConfig(
      fastDuration: _fastDuration,
      slowDuration: _slowDuration,
      cycles: _cycles,
      voiceGuidance: _voiceGuidance,
      musicIntegration: _musicIntegration,
    );

    // Update the provider
    ref.read(intervalConfigProvider.notifier).state = config;

    // Navigate to active session
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ActiveSessionScreen(),
      ),
    );
  }
}
