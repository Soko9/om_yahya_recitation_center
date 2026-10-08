import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  const new _();

  static TextStyle display({
    double size = 94,
    Color color = AppColors.indigo,
    FontWeight weight = .bold,
  }) => GoogleFonts.reemKufi(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: .75,
  );

  static TextStyle title({
    double size = 32,
    Color color = AppColors.indigo,
    FontWeight weight = .bold,
  }) => GoogleFonts.beiruti(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1,
  );

  static TextStyle body({
    double size = 24,
    Color color = AppColors.indigo,
    FontWeight weight = .normal,
  }) => GoogleFonts.beiruti(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1,
  );
}
