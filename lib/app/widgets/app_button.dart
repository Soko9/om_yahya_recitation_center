import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

enum ButtonMode { elevated, outlined }

class AppButton extends StatelessWidget {
  const new({
    required this.label,
    this.onTap,
    this.mode = .elevated,
    super.key,
  });

  final VoidCallback? onTap;
  final String label;
  final ButtonMode mode;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: mode == .outlined ? const Offset(6, 6) : .zero,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: .circular(4),
            boxShadow: [
              BoxShadow(
                offset: mode == .outlined
                    ? const Offset(-6, -6)
                    : const Offset(6, 6),
                color: mode == .outlined ? AppColors.red : Colors.black,
              ),
            ],
            border: .all(
              width: mode == .outlined ? 2 : 1,
              color: mode == .outlined ? AppColors.red : Colors.black,
            ),
            color: mode == .elevated ? AppColors.green : Colors.transparent,
          ),
          padding: const .symmetric(vertical: 8, horizontal: 24),
          child: Transform.translate(
            offset: mode == .outlined ? const Offset(-6, -6) : .zero,
            child: Text(
              label,
              style: AppTextStyles.body(
                color: AppColors.background,
                weight: .bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
