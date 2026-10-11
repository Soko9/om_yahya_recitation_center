import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/shared/custom_tile_clipper.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class AppTile extends StatelessWidget {
  const new({
    required this.qTitles,
    required this.qValues,
    required this.floatingWidget,
    required this.onTap,
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
  final Widget floatingWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const clipper = CustomTileClipper(radius: 12);

    return Padding(
      padding: const .all(24),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, child: floatingWidget),
            IntrinsicHeight(
              child: CustomPaint(
                painter: const PathShadowPainter(clipper),
                child: ClipPath(
                  clipper: clipper,
                  child: ColoredBox(
                    color: AppColors.amber,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const .symmetric(
                              vertical: 12,
                              horizontal: 18,
                            ),
                            child: Column(
                              mainAxisAlignment: .center,
                              crossAxisAlignment: .start,
                              spacing: 12,
                              children: [
                                if (title.isNotEmpty)
                                  Text(
                                    title,
                                    maxLines: 2,
                                    style: AppTextStyles.title(),
                                  ),
                                if (subtitle.isNotEmpty)
                                  Text(
                                    subtitle,
                                    style: AppTextStyles.title(size: 18),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const .symmetric(horizontal: 12),
                            child: Row(
                              spacing: 12,
                              children: [
                                for (var i = 0; i < qTitles.length; i++) ...[
                                  if (i > 0)
                                    Container(
                                      width: .5,
                                      height: 32,
                                      color: AppColors.indigo.withValues(
                                        alpha: .5,
                                      ),
                                    ),
                                  Expanded(
                                    child: _buildStat(qTitles[i], qValues[i]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String title, dynamic value) {
    return Column(
      mainAxisSize: .min,
      spacing: 6,
      children: [
        Text(title, style: AppTextStyles.body(weight: .bold)),
        Text('$value'.toArabicNumbers(), style: AppTextStyles.body()),
      ],
    );
  }
}
