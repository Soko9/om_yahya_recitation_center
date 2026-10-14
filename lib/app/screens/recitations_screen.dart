import 'dart:async';

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/app/models/surah_model.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/screens/add_recitation_sheet.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_fab.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_loader.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_tile.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
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
    final isBack = await showModalBottomSheet<bool>(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      isDismissible: false,
      showDragHandle: false,
      enableDrag: false,
      useSafeArea: true,
      barrierColor: Colors.black87,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: .circular(4)),
      builder: (context) => Padding(
        padding: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddRecitationSheet(tenant: widget.tenant),
      ),
    );

    if (isBack != null && isBack) await _loadRecitations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tenant.fullName, style: AppTextStyles.title()),
      ),
      floatingActionButtonLocation: .startFloat,
      floatingActionButton: AppFab(
        callback: _addRecitation,
        icon: Icons.bookmark_add_rounded,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: AppLoader())
            : _recitations.isEmpty
            ? Center(
                child: Text(
                  'لا يوجد تسميعات حاليا',
                  style: AppTextStyles.body(),
                ),
              )
            : RefreshIndicator(
                color: AppColors.indigo,
                backgroundColor: AppColors.background,
                strokeWidth: 4,
                elevation: 0,
                onRefresh: _loadRecitations,
                child: ListView.builder(
                  itemCount: _recitations.length,
                  itemBuilder: (context, index) {
                    final recitation = _recitations[index];
                    return _buildTile(recitation, context);
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildTile(RecitationModel recitation, BuildContext context) {
    final avgScore =
        (recitation.memoryScore +
            recitation.reciteScore +
            recitation.tajweedScore) ~/
        3;

    return AppTile(
      subtitle:
          '${SurahModel.surahs.where((s) => s.number == recitation.surahNumber).single.name} :   من ${recitation.startQVerse}  إلى  ${recitation.endQVerse}\nرواية :  ${recitation.rewayah.arabicLabel}\nفي :  ${recitation.recitedAt.toIso8601StringWithoutMilliseconds()}'
              .toArabicNumbers(),
      qTitles: const ['حفظ', 'تلاوة', 'أحكام'],
      qValues: [
        recitation.memoryScore,
        recitation.reciteScore,
        recitation.tajweedScore,
      ],
      score: avgScore,
      over: 10,
      onDelete: () async {
        await DbService.deleteRecitation(recitation.id);
        await _loadRecitations();
      },
    );
  }
}
