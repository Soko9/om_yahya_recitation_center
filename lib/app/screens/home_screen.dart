import 'dart:async';

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/app/screens/tenants_screen.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/app/widgets/app_divider.dart';
import 'package:om_yahya_recitation_center/app/widgets/recitation_tile.dart';
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
    unawaited(_loadRecitations());
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(const TenantsScreen());
        },
        elevation: 0,
        backgroundColor: AppColors.indigo,
        shape: RoundedRectangleBorder(borderRadius: .circular(4)),
        child: const Icon(
          Icons.groups_rounded,
          size: 42,
          color: AppColors.background,
        ),
      ),
      body: Column(
        children: [
          WeekdayPicker(selectedDate: _selectedDate, callback: _setDate),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_recitations.isEmpty)
            Center(
              child: Text(
                'لا يوجد تسميعات لهذا اليوم',
                style: AppTextStyles.body(),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _recitations.length,
                separatorBuilder: (context, index) => const AppDivider(),
                itemBuilder: (context, index) {
                  final recitation = _recitations[index];
                  return RecitationTile(recitation: recitation, index: index);
                },
              ),
            ),
        ],
      ),
    );
  }
}
