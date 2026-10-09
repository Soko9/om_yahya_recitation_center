import 'dart:async';

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_divider.dart';
import 'package:om_yahya_recitation_center/app/widgets/recitation_tile.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class RecitationsScreen extends StatefulWidget {
  const new({required this.tenant, super.key});

  final TenantModel tenant;

  @override
  State<RecitationsScreen> createState() => _RecitationsScreenState();
}

class _RecitationsScreenState extends State<RecitationsScreen> {
  bool _isLoading = false;
  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  final List<RecitationModel> _recitations = [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadRecitations());
  }

  Future<void> _loadRecitations() async {
    _setLoading(true);
    try {
      final recitations = await DbService.recitationsByTenant(widget.tenant.id);
      setState(() {
        _recitations
          ..clear()
          ..addAll(recitations);
      });
    } on Exception catch (_) {
      //! ADD ERROR HANDELING
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _addRecitation() async {
    final newRecitation = RecitationModel(
      id: DateTime.now().millisecondsSinceEpoch,
      tenantId: widget.tenant.id,
      qPart: 2,
      rewayah: QuranRewaya.ibnDhakwanAnIbnAmir,
      recitedAt: DateTime.now(),
      surahNumber: 2,
      startQVerse: 12,
      endQVerse: 134,
      memoryScore: 7,
      reciteScore: 8,
      tajweedScore: 8,
      tenant: widget.tenant,
    );

    await DbService.insertRecitation(newRecitation);
    await _loadRecitations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tenant.fullName, style: AppTextStyles.title()),
      ),
      floatingActionButtonLocation: .startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecitation,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: .circular(4)),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recitations.isEmpty
          ? Center(
              child: Text('لا يوجد تسميعات حاليا', style: AppTextStyles.body()),
            )
          : ListView.separated(
              itemCount: _recitations.length,
              separatorBuilder: (context, index) => const AppDivider(),
              itemBuilder: (context, index) {
                final recitation = _recitations[index];
                return RecitationTile(recitation: recitation, index: index);
              },
            ),
    );
  }
}
