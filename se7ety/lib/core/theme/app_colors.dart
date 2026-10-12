import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0F9D8E);
  static const Color primaryDark = Color(0xFF0B7A6F);
  static const Color primaryLight = Color(0xFF5FC4B8);

  static const Color secondary = Color(0xFF2D6CDF);

  static const Color background = Color(0xFFF7FAF9);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1B1F23);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF9A825);

  static const Color border = Color(0xFFE5E7EB);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, primaryDark],
  );
}
