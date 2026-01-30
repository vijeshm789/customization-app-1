import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand colors - Soft teal/blue gradient
  static const Color primaryTeal = Color(0xFF0D9488);
  static const Color primaryBlue = Color(0xFF0891B2);
  static const Color secondaryTeal = Color(0xFF14B8A6);
  static const Color lightTeal = Color(0xFF5EEAD4);

  // Gradient colors
  static const Color gradientStart = Color(0xFF0D9488);
  static const Color gradientEnd = Color(0xFF0891B2);

  // Background colors
  static const Color background = Color(0xFFF0FDFA);
  static const Color cardBackground = Colors.white;
  static const Color overlayBackground = Color(0x80000000);

  // Text colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Colors.white;

  // Accent colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border and divider
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFD1D5DB);

  // Selection colors
  static const Color selected = Color(0xFF0D9488);
  static const Color unselected = Color(0xFF9CA3AF);

  // Shadow color
  static const Color shadow = Color(0x1A000000);

  // Gradient for background
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D9488),
      Color(0xFF0891B2),
    ],
  );

  static const LinearGradient softBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFCCFBF1),
      Color(0xFFCFFAFE),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color(0xFFF0FDFA),
    ],
  );
}
