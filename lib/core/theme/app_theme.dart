import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';

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
  );
}
