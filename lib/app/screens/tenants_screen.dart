import 'dart:async';

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/surah_model.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/screens/add_tenant_sheet.dart';
import 'package:om_yahya_recitation_center/app/screens/recitations_screen.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_fab.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_loader.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_tile.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class TenantsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<TenantsScreen> createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen> {
  bool _isLoading = false;
  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  final List<TenantModel> _tenants = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadTenants());
  }

  Future<void> _loadTenants() async {
    _setLoading(true);
    try {
      final tenants = await DbService.tenants();
      setState(() {
        _tenants
          ..clear()
          ..addAll(tenants);
      });
    } on Exception catch (_) {
      //! ADD ERROR HANDELING
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _addTenant() async {
    final isBack = await showModalBottomSheet<bool>(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      isDismissible: false,
      showDragHandle: false,
      enableDrag: false,
      barrierColor: Colors.black87,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: .circular(4)),
      builder: (context) => const AddTenantSheet(),
    );

    if (isBack != null && isBack) await _loadTenants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الطلاب', style: AppTextStyles.title()),
        actionsPadding: const .all(8),
        actions: [AppFab(callback: _addTenant, icon: Icons.person_add_rounded)],
      ),
      body: _isLoading
          ? const Center(child: AppLoader())
          : _tenants.isEmpty
          ? Center(
              child: Text('لا يوجد طلاب حاليا', style: AppTextStyles.body()),
            )
          : RefreshIndicator(
              color: AppColors.indigo,
              backgroundColor: AppColors.background,
              strokeWidth: 4,
              elevation: 0,
              onRefresh: _loadTenants,
              child: ListView.builder(
                itemCount: _tenants.length,
                itemBuilder: (context, index) {
                  final tenant = _tenants[index];
                  return _buildTile(tenant, context);
                },
              ),
            ),
    );
  }

  Widget _buildTile(TenantModel tenant, BuildContext context) {
    return AppTile(
      title: tenant.fullName,
      subtitle:
          'انضم في  ${tenant.joinedAt.toIso8601StringWithoutMilliseconds().toArabicNumbers()}',
      qTitles: const ['آخر  سورة', 'آخر  جزء', 'آخر  آية'],
      qValues: [
        SurahModel.surahs
            .where((s) => s.number == tenant.latestSurahNumber)
            .single
            .name,
        tenant.latestQPart,
        tenant.latestQVerse,
      ],
      onTap: () async {
        await context.push(RecitationsScreen(tenant: tenant));
      },
      floatingWidget: Container(
        padding: const .all(24),
        decoration: BoxDecoration(
          color: (tenant.avgScoreFromHundred <= 59
              ? AppColors.red
              : tenant.avgScoreFromHundred <= 79
              ? AppColors.orange
              : AppColors.green),
          shape: .circle,
          boxShadow: const [BoxShadow(offset: Offset(6, 6))],
        ),
        child: Text(
          '100  /  ${tenant.avgScoreFromHundred}'.toArabicNumbers(),
          style: AppTextStyles.title(color: AppColors.background),
        ),
      ),
    );
  }
}
