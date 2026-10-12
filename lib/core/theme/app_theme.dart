import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  const new _();

  static ThemeData get lightTheme => ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.background,
      shadowColor: Colors.transparent,
      surfaceTintColor: AppColors.background,
    ),
    datePickerTheme: _datePickerTheme(),
    inputDecorationTheme: _inputTheme(),
    sliderTheme: const SliderThemeData(trackHeight: 16),
  );

  static InputDecorationThemeData _inputTheme() {
    return InputDecorationThemeData(
      filled: true,
      fillColor: AppColors.softContainer.withValues(alpha: .6),
      border: .none,
      enabledBorder: .none,
      focusedBorder: .none,
      errorBorder: .none,
      outlineBorder: .none,
      disabledBorder: .none,
      focusedErrorBorder: .none,
      activeIndicatorBorder: .none,
      errorStyle: AppTextStyles.body(
        color: AppColors.red,
        size: 18,
        weight: .bold,
      ),
      hintStyle: AppTextStyles.body(),
    );
  }

  static DatePickerThemeData _datePickerTheme() {
    return DatePickerThemeData(
      // Dialog shape
      shape: RoundedRectangleBorder(borderRadius: .circular(4)),

      // Header
      headerBackgroundColor: AppColors.indigo,
      headerForegroundColor: AppColors.background,
      headerHeadlineStyle: AppTextStyles.title(),
      headerHelpStyle: AppTextStyles.body(),
      toggleButtonTextStyle: AppTextStyles.body(),

      // Calendar
      weekdayStyle: AppTextStyles.body(size: 18, weight: .bold),
      dayStyle: AppTextStyles.body(),
      yearStyle: AppTextStyles.body(),
      dayOverlayColor: WidgetStatePropertyAll(
        AppColors.indigo.withValues(alpha: .3),
      ),
      todayBorder: const BorderSide(color: AppColors.green),
      todayBackgroundColor: const WidgetStatePropertyAll(AppColors.green),
      todayForegroundColor: const WidgetStatePropertyAll(AppColors.background),
      backgroundColor: AppColors.background,

      // Selected date
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.indigo;
        }
        return null;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.background;
        }
        return null;
      }),

      // Action buttons
      cancelButtonStyle: TextButton.styleFrom(
        textStyle: AppTextStyles.body(size: 18, weight: .bold),
        foregroundColor: AppColors.red,
      ),
      confirmButtonStyle: TextButton.styleFrom(
        textStyle: AppTextStyles.body(size: 18, weight: .bold),
        foregroundColor: AppColors.indigo,
      ),
    );
  }
}
