import 'package:flutter/material.dart';

/// Palette source of truth — reference these constants from
/// `app_theme.dart`, never hardcode colors in feature code.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2962FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1A1C1E);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
}
