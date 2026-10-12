import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';

class AppFab extends StatelessWidget {
  const new({required this.callback, required this.icon, super.key});

  final VoidCallback callback;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: callback,
      elevation: 0,
      hoverElevation: 0,
      backgroundColor: AppColors.indigo,
      shape: RoundedRectangleBorder(borderRadius: .circular(4)),
      child: Icon(icon, size: 42, color: AppColors.background),
    );
  }
}
