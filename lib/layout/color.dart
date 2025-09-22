import 'package:flutter/material.dart';

/// Centralized colors for Feszora project
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF2563EB); // Blue
  static const Color primaryDark = Color(0xFF1E40AF); // Darker Blue
  static const Color accent = Color(0xFF10B981); // Teal/Green accent

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color gray = Color(0xFF9CA3AF); // Neutral gray
  static const Color darkGray = Color(0xFF4B5563); // Dark gray
  static const Color lightGray = Color(0xFFF3F4F6); // Background gray

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF9FAFB);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF22C55E); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444);   // Red
  static const Color info = Color(0xFF3B82F6);    // Blue info

  // Gradients (optional)
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
