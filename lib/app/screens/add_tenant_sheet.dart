import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class AddTenantSheet extends StatefulWidget {
  const new({super.key});

  @override
  State<AddTenantSheet> createState() => _AddTenantSheetState();
}

class _AddTenantSheetState extends State<AddTenantSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  DateTime _joinedDate = DateTime.now();
  void _setJoinedDate(DateTime date) {
    setState(() {
      _joinedDate = date;
    });
  }

  Future<void> _addTenant() async {
    if (_formKey.currentState!.validate()) {
      final tenant = TenantModel(
        id: DateTime.now().millisecondsSinceEpoch,
        firstName: _firstNameController.text.trim(),
        middleName: _middleNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        joinedAt: _joinedDate,
      );

      await DbService.insertTenant(tenant);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sh * .65,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const .all(12),
          child: Column(
            spacing: 12,
            crossAxisAlignment: .stretch,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'إضافة طالب جديد',
                    style: AppTextStyles.display(size: 32),
                  ),
                  Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      IconButton.filled(
                        onPressed: _addTenant,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.green.withValues(
                            alpha: .6,
                          ),
                        ),
                        icon: const Icon(Icons.check),
                        iconSize: 32,
                        color: AppColors.indigo,
                      ),
                      IconButton.filled(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.red.withValues(alpha: .6),
                        ),
                        icon: const Icon(Icons.clear),
                        iconSize: 32,
                        color: AppColors.indigo,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firstNameController,
                style: AppTextStyles.body(weight: .bold),
                decoration: const InputDecoration(hintText: 'الإسم الأول'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'الحقل إجباري';
                  if (value.length < 3) {
                    return 'يجب أن يكون 3 أحرف فأكثر'.toArabicNumbers();
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _middleNameController,
                style: AppTextStyles.body(weight: .bold),
                decoration: const InputDecoration(hintText: 'إسم الأب'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'الحقل إجباري';
                  if (value.length < 3) {
                    return 'يجب أن يكون 3 أحرف فأكثر'.toArabicNumbers();
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                style: AppTextStyles.body(weight: .bold),
                decoration: const InputDecoration(hintText: 'إسم العائلة'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'الحقل إجباري';
                  if (value.length < 3) {
                    return 'يجب أن يكون 3 أحرف فأكثر'.toArabicNumbers();
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: TextEditingController(
                  text:
                      'التاريخ:   ${_joinedDate.toIso8601StringWithoutMilliseconds().toArabicNumbers()}',
                ),
                style: AppTextStyles.body(weight: .bold),
                readOnly: true,
                selectAllOnFocus: false,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    helpText: 'تاريخ الإنضمام',
                    barrierColor: Colors.black87,
                    currentDate: DateTime.now(),
                    locale: const Locale('ar', 'EG'),
                    textDirection: .rtl,
                    initialEntryMode: .calendarOnly,
                  );
                  if (date != null) _setJoinedDate(date);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
