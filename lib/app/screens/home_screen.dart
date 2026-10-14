import 'dart:async';

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/app/models/surah_model.dart';
import 'package:om_yahya_recitation_center/app/screens/tenants_screen.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_fab.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_loader.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_tile.dart';
import 'package:om_yahya_recitation_center/app/widgets/weekday_picker.dart';
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

  DateTime _selectedDate = DateTime.now();
  Future<void> _setDate(DateTime date) async {
    setState(() {
      _selectedDate = date;
    });
    await _loadRecitations();
  }

  final List<RecitationModel> _recitations = [];

  @override
  void initState() {
    super.initState();
    // unawaited(_deleteUnusedRecitations());
    unawaited(_loadRecitations());
  }

  // Future<void> _deleteUnusedRecitations() async {
  //   _setLoading(true);
  //   try {
  //     await DbService.deleteLatest5Days();
  //   } on Exception catch (_) {
  //     //! ADD ERROR HANDELING
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future<void> _loadRecitations() async {
    _setLoading(true);
    try {
      final recitations = await DbService.recitationsByDate(_selectedDate);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: .startFloat,
      floatingActionButton: AppFab(
        callback: () async {
          await context.push(const TenantsScreen());
        },
        icon: Icons.groups_rounded,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.indigo,
          backgroundColor: AppColors.background,
          strokeWidth: 4,
          elevation: 0,
          onRefresh: _loadRecitations,
          child: Column(
            children: [
              AbsorbPointer(
                absorbing: _isLoading,
                child: WeekdayPicker(
                  selectedDate: _selectedDate,
                  callback: _setDate,
                ),
              ),
              if (_isLoading)
                const Expanded(child: Center(child: AppLoader()))
              else if (_recitations.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'لا يوجد تسميعات لهذا اليوم',
                      style: AppTextStyles.body(),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _recitations.length,
                    itemBuilder: (context, index) {
                      final recitation = _recitations[index];
                      return _buildTile(recitation, context);
                    },
                  ),
                ),
            ],
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
          '${SurahModel.surahs.where((s) => s.number == recitation.surahNumber).single.name}   -   من ${recitation.startQVerse}  إلى  ${recitation.endQVerse}\nرواية   -   ${recitation.rewayah.arabicLabel}'
              .toArabicNumbers(),
      qTitles: const ['الطالب'],
      qValues: [recitation.tenant?.fullName],
      score: avgScore,
      over: 10,
    );
  }
}
