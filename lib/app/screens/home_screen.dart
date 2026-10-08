import 'dart:async';

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _addTenant() async {
    final newTenant = TenantModel(
      id: DateTime.now().millisecondsSinceEpoch,
      firstName: 'أحمد',
      middleName: 'محمد',
      lastName: 'خالد',
      joinedAt: DateTime.now(),
    );

    await DbService.insertTenant(newTenant);
    await _loadTenants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addTenant,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tenants.isEmpty
          ? Center(
              child: Text('لا يوجد طلاب حاليا', style: AppTextStyles.body()),
            )
          : ListView.separated(
              itemCount: _tenants.length,
              separatorBuilder: (context, index) => Container(
                height: .75,
                margin: const .only(top: 8, bottom: 2, left: 12, right: 12),
                color: AppColors.green,
              ),
              itemBuilder: (context, index) {
                final tenant = _tenants[index];
                return ListTile(
                  title: Text(tenant.fullName, style: AppTextStyles.title()),
                  subtitle: Text(
                    'انضم في: ${tenant.joinedAt.toIso8601StringWithoutMilliseconds().toArabicNumbers()}',
                    style: AppTextStyles.body(size: 18),
                  ),
                );
              },
            ),
    );
  }
}
