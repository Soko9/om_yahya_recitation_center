import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/surah_model.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/screens/recitations_screen.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class TenantTile extends StatelessWidget {
  const new({required this.tenant, super.key});

  final TenantModel tenant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(24),
      child: GestureDetector(
        onTap: () async {
          await context.push(RecitationsScreen(tenant: tenant));
        },
        child: Stack(
          children: [
            Positioned(
              top: 6,
              left: 0,
              child: Container(
                padding: const .symmetric(horizontal: 32, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      (tenant.avgScoreFromHundred <= 59
                              ? AppColors.red
                              : tenant.avgScoreFromHundred <= 79
                              ? AppColors.orange
                              : AppColors.green)
                          .withValues(alpha: .35),
                  borderRadius: .circular(18),
                ),
                child: Text(
                  '${tenant.avgScoreFromHundred}  /  100'.toArabicNumbers(),
                  style: AppTextStyles.title(),
                ),
              ),
            ),
            IntrinsicHeight(
              child: ClipPath(
                clipper: const CustomTileClipper(),
                child: Container(
                  width: .infinity,
                  color: AppColors.orange,
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
                              Text(
                                tenant.fullName,
                                maxLines: 2,
                                style: AppTextStyles.title(),
                              ),
                              Text(
                                'انضم في  ${tenant.joinedAt.toIso8601StringWithoutMilliseconds().toArabicNumbers()}',
                                style: AppTextStyles.body(size: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const .all(12),
                          child: Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                child: _buildStat(
                                  'آخر  سورة',
                                  SurahModel.surahs
                                      .where(
                                        (s) =>
                                            s.number ==
                                            tenant.latestSurahNumber,
                                      )
                                      .single
                                      .name,
                                ),
                              ),
                              Container(
                                width: .5,
                                height: 32,
                                color: AppColors.indigo.withValues(alpha: .5),
                              ),
                              Expanded(
                                child: _buildStat(
                                  'آخر  جزء',
                                  tenant.latestQPart,
                                ),
                              ),
                              Container(
                                width: .5,
                                height: 32,
                                color: AppColors.indigo.withValues(alpha: .5),
                              ),
                              Expanded(
                                child: _buildStat(
                                  'آخر  آية',
                                  tenant.latestQVerse,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
        Text('$value', style: AppTextStyles.body()),
      ],
    );
  }
}

class CustomTileClipper extends CustomClipper<Path> {
  const new({this.radius = 32});

  final double radius;

  @override
  Path getClip(Size size) {
    final gapSize = size * .35;

    final path = Path()
      ..moveTo(gapSize.width + radius, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      )
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - radius)
      ..lineTo(0, gapSize.height + radius)
      ..quadraticBezierTo(0, gapSize.height, radius, gapSize.height)
      ..lineTo(gapSize.width - radius, gapSize.height)
      ..quadraticBezierTo(
        gapSize.width,
        gapSize.height,
        gapSize.width,
        gapSize.height - radius,
      )
      ..lineTo(gapSize.width, radius)
      ..quadraticBezierTo(gapSize.width, 0, gapSize.width + radius, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) => true;
}
