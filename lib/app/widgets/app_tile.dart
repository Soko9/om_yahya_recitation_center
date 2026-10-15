import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_button.dart';
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
    this.notes,
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
  final String? notes;

  Future<void> _showConfirmingDialog(BuildContext context) async {
    final fromTenant = onTap != null;

    await showDialog<dynamic>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: .circular(4)),
          backgroundColor: AppColors.background,
          shadowColor: Colors.black,
          elevation: 0,
          title: Text(
            'متأكد من مسح هذا ${fromTenant ? 'الطالب؟' : 'التسميع؟'}',
          ),
          titleTextStyle: AppTextStyles.title(),
          actionsAlignment: .spaceBetween,
          icon: const Icon(Icons.nearby_error, size: 64),
          iconColor: AppColors.red,
          iconPadding: const .all(8),
          actions: [
            AppButton(
              label: 'متأكد',
              onTap: () {
                onDelete?.call();
                context.pop();
              },
            ),
            AppButton(
              label: 'رجوع',
              onTap: () {
                context.pop();
              },
              mode: .outlined,
            ),
          ],
        );
      },
    );
  }

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
                      if (notes != null) const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: .start,
                        spacing: 8,
                        children: [
                          if (title.isNotEmpty)
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 2,
                                style: AppTextStyles.title(),
                              ),
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
                          if (notes != null)
                            Expanded(
                              child: Container(
                                padding: const .all(8),
                                decoration: BoxDecoration(
                                  border: .all(),
                                  borderRadius: .circular(4),
                                ),
                                child: Column(
                                  mainAxisSize: .min,
                                  spacing: 12,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      'ملاحظات:',
                                      style: AppTextStyles.body(
                                        size: 18,
                                        weight: .bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          notes!,
                                          overflow: .fade,
                                          style: AppTextStyles.body(size: 18),
                                        ),
                                      ),
                                    ),
                                  ],
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
                onTap: () async => await _showConfirmingDialog(context),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: .circle,
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    size: 28,
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
