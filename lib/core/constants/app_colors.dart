import 'package:flutter/material.dart';

/// App color constants inspired by Japanese aesthetics
class AppColors {
  AppColors._();

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightPrimary = Color(0xFFDC143C); // Crimson red - Japanese flag
  static const Color lightSecondary = Color(0xFF2C2C2C); // Deep charcoal
  static const Color lightAccent = Color(0xFFFF6B6B); // Coral red
  static const Color lightSuccess = Color(0xFF4CAF50); // Japanese green - completed walks
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkPrimary = Color(0xFFFF4444);
  static const Color darkSecondary = Color(0xFFECECEC);
  static const Color darkAccent = Color(0xFFFF8080);
  static const Color darkSuccess = Color(0xFF66BB6A); // Lighter green for dark mode
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFCCCCCC);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkDivider = Color(0xFF3A3A3A);

  // Interval Colors (used in timer)
  static const Color fastInterval = Color(0xFFFF4444); // Red
  static const Color slowInterval = Color(0xFF42A5F5); // Blue
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPrimary, lightAccent],
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkPrimary, darkAccent],
  );
}
