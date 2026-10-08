import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class RecitationTile extends StatelessWidget {
  const new({required this.recitation, required this.index, super.key});

  final RecitationModel recitation;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.orange,
          child: Text(
            '${index + 1}'.toArabicNumbers(),
            style: AppTextStyles.body(weight: .bold),
          ),
        ),
        title: Text(
          recitation.recitedAt
              .toIso8601StringWithoutMilliseconds()
              .toArabicNumbers(),
          style: AppTextStyles.title(),
        ),
        subtitle: Text(
          '${recitation.memoryScore}  |  ${recitation.reciteScore}  |  ${recitation.tajweedScore}'
              .toArabicNumbers(),
          style: AppTextStyles.body(
            color: AppColors.red,
            weight: .bold,
          ).copyWith(height: 1.2),
        ),
      ),
    );
  }
}
