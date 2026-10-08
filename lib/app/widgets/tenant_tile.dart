import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/screens/recitations_screen.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class TenantTile extends StatelessWidget {
  const new({required this.tenant, super.key});

  final TenantModel tenant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await context.push(RecitationsScreen(tenant: tenant));
      },
      child: ListTile(
        title: Text(tenant.fullName, style: AppTextStyles.title()),
        subtitle: Text(
          'انضم في: ${tenant.joinedAt.toIso8601StringWithoutMilliseconds().toArabicNumbers()}',
          style: AppTextStyles.body(size: 18),
        ),
      ),
    );
  }
}
