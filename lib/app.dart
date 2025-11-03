import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_theme.dart';
import 'features/splash/presentation/splash_screen.dart';

/// Main application widget
class JapaneseWalkingApp extends ConsumerWidget {
  const JapaneseWalkingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Japanese Walking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // TODO: Connect to settings provider in Phase 5
      home: const SplashScreen(),
    );
  }
}
