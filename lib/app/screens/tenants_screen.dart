import 'dart:async';

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/app/widgets/tenant_tile.dart';
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
      appBar: AppBar(
        title: Text('الطلاب', style: AppTextStyles.title()),
        actionsPadding: const .all(8),
        actions: [
          FloatingActionButton(
            onPressed: _addTenant,
            elevation: 0,
            backgroundColor: AppColors.indigo,
            shape: RoundedRectangleBorder(borderRadius: .circular(4)),
            child: const Icon(
              Icons.person_add_rounded,
              color: AppColors.background,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tenants.isEmpty
          ? Center(
              child: Text('لا يوجد طلاب حاليا', style: AppTextStyles.body()),
            )
          : ListView.builder(
              itemCount: _tenants.length,
              itemBuilder: (context, index) {
                final tenant = _tenants[index];
                return TenantTile(tenant: tenant);
              },
            ),
    );
  }
}
