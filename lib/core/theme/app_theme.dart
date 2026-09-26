import 'package:flutter/material.dart';
import 'package:mmf/core/theme/app_colors.dart';
import 'package:mmf/core/theme/app_spacing.dart';

abstract final class AppTheme {
  static const String fontFamily = 'SFProDisplay';

  static ThemeData get light => ThemeData(
        cardTheme: CardThemeData(color: AppColors.white1, elevation: 1, shadowColor: Colors.black.withValues(alpha: 0.05), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
        checkboxTheme: CheckboxThemeData(
          checkColor: const WidgetStatePropertyAll(AppColors.white1),
          fillColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppColors.green3 : Colors.transparent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xs)),
          side: const BorderSide(color: AppColors.outlineGray, width: AppSpacing.borderThick),
        ),
        colorScheme: ColorScheme.fromSeed(error: AppColors.red, primary: AppColors.green3, secondary: AppColors.green1, seedColor: AppColors.green2),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green3,
            elevation: 0,
            foregroundColor: AppColors.white1,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.xxl),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            textStyle: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
        ),
        fontFamily: fontFamily,
        inputDecorationTheme: InputDecorationTheme(
          border: _outline(AppColors.outlineGray),
          contentPadding: const EdgeInsets.all(AppSpacing.lg),
          enabledBorder: _outline(AppColors.outlineGray),
          errorBorder: _outline(AppColors.red),
          fillColor: AppColors.white1,
          filled: true,
          floatingLabelStyle: const TextStyle(color: AppColors.green3, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500),
          focusedBorder: _outline(AppColors.green3, AppSpacing.borderThick),
          focusedErrorBorder: _outline(AppColors.red, AppSpacing.borderThick),
          hintStyle: const TextStyle(color: AppColors.gray5, fontFamily: fontFamily, fontSize: 16),
          labelStyle: const TextStyle(color: AppColors.gray5, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.xxl),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            side: const BorderSide(color: AppColors.outlineGray, width: AppSpacing.borderMedium),
            textStyle: const TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        scaffoldBackgroundColor: AppColors.white5,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.black, fontSize: 16),
          bodyMedium: TextStyle(color: AppColors.black, fontSize: 14),
          titleLarge: TextStyle(color: AppColors.black, fontSize: 28, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        useMaterial3: true,
      );

  static OutlineInputBorder _outline(Color color, [double width = AppSpacing.borderThin]) => OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide(color: color, width: width));
}
