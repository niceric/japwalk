import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../walking_session/presentation/pre_walk_setup_screen.dart';

/// Main dashboard screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = AppStrings.goodMorning;
    } else if (hour < 18) {
      greeting = AppStrings.goodAfternoon;
    } else {
      greeting = AppStrings.goodEvening;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                greeting,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Japanese Walking!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PreWalkSetupScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.directions_walk),
                label: const Text(AppStrings.startWalk),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tap the button above to start your walking session',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
