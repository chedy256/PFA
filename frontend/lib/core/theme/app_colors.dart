import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF0066CC);
  static const Color primaryLight = Color(0xFF4D94DB);
  static const Color primaryDark = Color(0xFF004C99);

  static const Color secondary = Color(0xFF6C63FF);
  static const Color accent = Color(0xFFFFD700);

  static const Color background = Color(0xFFF8F9FD);
  static const Color surface = Colors.white;
  static const Color cardBackground = Color(
    0xFFF0F0F0,
  ); // Reverted to previous slightly grey color

  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF42474E);
  static const Color textTertiary = Color(0xFF72777F);
  static const Color textGrey = Color(0xFF9EA4AA);
  static const Color textInverse = Colors.white;

  // Borders and Shadows
  static const Color border = Color(0xFFE0E6ED);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color shadow = Color(0x0C000000); // 5% opacity black

  static const Color success = Color(0xFF2E8B57);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF3B82F6);

  static const Color yellow = warning;
  static const Color green = success;
  static const Color blue = primary;
  static const Color purple = secondary;
  static const Color red = error;

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF141414);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardBackground = Color(0xFF252525);
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkBorderLight = Color(0xFF2A2A2A);

  static const Color darkTextPrimary = Color(0xFFE3E3E3);
  static const Color darkTextSecondary = Color(0xFFA0A0A0);
  static const Color darkTextTertiary = Color(0xFF707070);
  static const Color darkTextGrey = Color(0xFF555555);
}
