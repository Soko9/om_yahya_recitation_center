import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class AppTile extends StatelessWidget {
  const new({
    required this.qTitles,
    required this.qValues,
    required this.score,
    required this.over,
    this.onTap,
    this.onDelete,
    this.title = '',
    this.subtitle = '',
    super.key,
  }) : assert(
         qTitles.length == qValues.length,
         'qTitles & qValues should be the same length',
       );

  final String title;
  final String subtitle;
  final List<String> qTitles;
  final List<dynamic> qValues;
  final int score;
  final int over;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final backColor = onTap == null
        ? AppColors.softContainer
        : AppColors.container;
    const frontColor = AppColors.indigo;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backColor,
              borderRadius: .circular(4),
              boxShadow: const [BoxShadow(offset: Offset(6, 6))],
              border: Border.all(),
            ),
            margin: const .all(24),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const .all(12),
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    spacing: 12,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              maxLines: 2,
                              style: AppTextStyles.title(),
                            ),
                          Container(
                            padding: const .all(12),
                            decoration: BoxDecoration(
                              color: (score <= (over * .6) - 1
                                  ? AppColors.red
                                  : score <= (over * .8) - 1
                                  ? AppColors.orange
                                  : AppColors.green),
                              borderRadius: .circular(4),
                              border: Border.all(),
                              boxShadow: const [
                                BoxShadow(offset: Offset(6, 6)),
                              ],
                            ),
                            child: Text(
                              '$over  /  $score'.toArabicNumbers(),
                              style: AppTextStyles.body(
                                weight: .bold,
                                color: AppColors.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: AppTextStyles.title(size: 18)
                              .copyWith(height: 1.5),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const .all(12),
                  child: Row(
                    spacing: 12,
                    children: [
                      for (var i = 0; i < qTitles.length; i++) ...[
                        if (i > 0)
                          Container(
                            width: .5,
                            height: 32,
                            color: frontColor.withValues(alpha: .5),
                          ),
                        Expanded(
                          child: _buildStat(qTitles[i], qValues[i], frontColor),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            Positioned(
              right: onTap == null ? null : 38,
              left: onTap == null ? 38 : null,
              top: 0,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: .circular(4),
                    border: .all(),
                    boxShadow: const [BoxShadow(offset: Offset(3, 3))],
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(String title, dynamic value, Color color) {
    return Column(
      mainAxisSize: .min,
      spacing: 6,
      children: [
        Text(
          title,
          style: AppTextStyles.body(weight: .bold, color: color),
        ),
        Text(
          '$value'.toArabicNumbers(),
          style: AppTextStyles.body(color: color),
        ),
      ],
    );
  }
}
