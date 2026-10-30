import 'package:flutter/material.dart';

/// Campusly Design System Color Tokens
class AppColors {
  // Brand Primary & Accents (Light & Common)
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color secondary = Color(0xFF8B5CF6); // Purple
  static const Color accentCyan = Color(0xFF06B6D4); // Cyan highlight

  // Light Theme Surfaces & Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightElevated = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Light Theme Typography
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Dark Theme Surfaces & Backgrounds
  static const Color backgroundDark = Color(0xFF0B1120);
  static const Color surfaceDark = Color(0xFF172033);
  static const Color surfaceDarkElevated = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF334155);

  // Dark Theme Typography
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color primaryAccentDark = Color(0xFFA5B4FC);

  // Feedback & Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successBgLight = Color(0xFFECFDF5);
  static const Color successBgDark = Color(0xFF064E3B);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBgLight = Color(0xFFFFFBEB);
  static const Color warningBgDark = Color(0xFF78350F);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBgLight = Color(0xFFFEF2F2);
  static const Color errorBgDark = Color(0xFF7F1D1D);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBgLight = Color(0xFFEFF6FF);
  static const Color infoBgDark = Color(0xFF1E3A8A);

  // Soft Pastel Tint Backgrounds
  static const Color softLavender = Color(0xFFEEF2FF);
  static const Color softLavenderDark = Color(0xFF1E1B4B);

  static const Color softMint = Color(0xFFECFDF5);
  static const Color softMintDark = Color(0xFF064E3B);

  static const Color softAmber = Color(0xFFFEF3C7);
  static const Color softAmberDark = Color(0xFF451A03);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient darkHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
  );
}
