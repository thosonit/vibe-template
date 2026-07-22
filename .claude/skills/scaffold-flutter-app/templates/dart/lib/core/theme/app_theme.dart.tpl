import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Light/dark [ThemeData] assembly — the only place `ColorScheme`/`TextTheme`
/// are constructed from [AppColors]/[AppTextStyles].
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        textTheme: const TextTheme(
          headlineMedium: AppTextStyles.headline,
          bodyMedium: AppTextStyles.body,
          labelLarge: AppTextStyles.label,
        ),
      );
}
