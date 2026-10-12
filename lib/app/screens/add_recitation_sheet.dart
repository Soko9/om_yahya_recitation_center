import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/app/models/surah_model.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class AddRecitationSheet extends StatefulWidget {
  const new({required this.tenant, super.key});

  final TenantModel tenant;

  @override
  State<AddRecitationSheet> createState() => _AddRecitationSheetState();
}

class _AddRecitationSheetState extends State<AddRecitationSheet> {
  DateTime _reciteDate = DateTime.now();
  void _setRecitationDate(DateTime date) {
    setState(() {
      _reciteDate = date;
    });
  }

  QuranRewaya _rewaya = QuranRewaya.hafsAnAsim;
  void _setRewaya(QuranRewaya rewaya) {
    setState(() {
      _rewaya = rewaya;
    });
  }

  int _surahNumber = 1;
  void _setSurahNumber(int number) {
    setState(() {
      _surahNumber = number;
    });
  }

  int _qPart = 1;
  void _setQPart(int qPart) {
    setState(() {
      _qPart = qPart;
    });
  }

  final minScore = 0;
  final maxScore = 10;

  int _memoryScore = 0;
  void _setMemoryScore(int score) {
    setState(() {
      _memoryScore = score;
    });
  }

  int _reciteScore = 0;
  void _setReciteScore(int score) {
    setState(() {
      _reciteScore = score;
    });
  }

  int _tajweedScore = 0;
  void _setTajweedScore(int score) {
    setState(() {
      _tajweedScore = score;
    });
  }

  final GlobalKey<FormState> _fromKey = GlobalKey();
  final TextEditingController _startVerse = TextEditingController();
  final TextEditingController _endVerse = TextEditingController();

  Future<void> _addRecitation() async {
    if (_fromKey.currentState!.validate()) {
      final newRecitation = RecitationModel(
        id: DateTime.now().millisecondsSinceEpoch,
        tenantId: widget.tenant.id,
        rewayah: _rewaya,
        recitedAt: _reciteDate,
        surahNumber: _surahNumber,
        qPart: _qPart,
        startQVerse: int.parse(_startVerse.text.trim()),
        endQVerse: int.parse(_endVerse.text.trim()),
        memoryScore: _memoryScore,
        reciteScore: _reciteScore,
        tajweedScore: _tajweedScore,
        tenant: widget.tenant,
      );

      await DbService.insertRecitation(newRecitation);

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _startVerse.dispose();
    _endVerse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sh * .85,
      child: Padding(
        padding: const .all(12),
        child: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 12,
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      'إضافة تسميع جديد',
                      style: AppTextStyles.display(size: 32),
                    ),
                    Row(
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        IconButton.filled(
                          onPressed: _addRecitation,
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
                            backgroundColor: AppColors.red.withValues(
                              alpha: .6,
                            ),
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
                SizedBox(
                  height: context.sh * .2,
                  child: Column(
                    crossAxisAlignment: .stretch,
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      Text('الرواية', style: AppTextStyles.body(weight: .bold)),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            alignment: .center,
                            runAlignment: .center,
                            crossAxisAlignment: .center,
                            children: QuranRewaya.values
                                .map(_buildRewaya)
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: .stretch,
                  spacing: 8,
                  children: [
                    Text('الجزء', style: AppTextStyles.body(weight: .bold)),
                    SingleChildScrollView(
                      scrollDirection: .horizontal,
                      child: Row(
                        crossAxisAlignment: .start,
                        spacing: 8,
                        children: List.generate(30, (i) => _buildPart(i + 1)),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: .stretch,
                  spacing: 8,
                  children: [
                    Text('السورة', style: AppTextStyles.body(weight: .bold)),
                    SingleChildScrollView(
                      scrollDirection: .horizontal,
                      child: Row(
                        crossAxisAlignment: .start,
                        spacing: 8,
                        children: [
                          for (final surah in SurahModel.surahs.where(
                            (surah) => surah.partNumbers.contains(_qPart),
                          ))
                            _buildSurah(surah),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 24,
                  children: [
                    Row(
                      spacing: 12,
                      children: [
                        Text('من', style: AppTextStyles.body(weight: .bold)),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _startVerse,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'حقل إجباري';
                              }
                              final v = int.parse(value);
                              if (v <= 0) return '1 أقل رقم'.toArabicNumbers();
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Text('إلى', style: AppTextStyles.body(weight: .bold)),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _endVerse,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'حقل إجباري';
                              }
                              final v = int.parse(value);
                              if (v >
                                  SurahModel.surahs
                                      .singleWhere(
                                        (s) => s.number == _surahNumber,
                                      )
                                      .numberOfVerses) {
                                return 'X';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'الحفظ',
                        style: AppTextStyles.body(weight: .bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                        min: minScore.toDouble(),
                        max: maxScore.toDouble(),
                        divisions: 10,
                        activeColor: AppColors.green,
                        inactiveColor: AppColors.softContainer,
                        showValueIndicator: .never,
                        label: '$_memoryScore'.toArabicNumbers(),
                        value: _memoryScore.toDouble(),
                        onChanged: (value) => _setMemoryScore(value.toInt()),
                      ),
                    ),
                    Text(
                      '$_memoryScore'.toArabicNumbers(),
                      style: AppTextStyles.body(weight: .bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'التلاوة',
                        style: AppTextStyles.body(weight: .bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                        min: minScore.toDouble(),
                        max: maxScore.toDouble(),
                        divisions: 10,
                        activeColor: AppColors.orange,
                        inactiveColor: AppColors.softContainer,
                        showValueIndicator: .never,
                        label: '$_reciteScore'.toArabicNumbers(),
                        value: _reciteScore.toDouble(),
                        onChanged: (value) => _setReciteScore(value.toInt()),
                      ),
                    ),
                    Text(
                      '$_reciteScore'.toArabicNumbers(),
                      style: AppTextStyles.body(weight: .bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'الاحكام',
                        style: AppTextStyles.body(weight: .bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                        min: minScore.toDouble(),
                        max: maxScore.toDouble(),
                        divisions: 10,
                        activeColor: AppColors.red,
                        inactiveColor: AppColors.softContainer,
                        showValueIndicator: .never,
                        label: '$_tajweedScore'.toArabicNumbers(),
                        value: _tajweedScore.toDouble(),
                        onChanged: (value) => _setTajweedScore(value.toInt()),
                      ),
                    ),
                    Text(
                      '$_tajweedScore'.toArabicNumbers(),
                      style: AppTextStyles.body(weight: .bold),
                    ),
                  ],
                ),
                TextFormField(
                  controller: TextEditingController(
                    text:
                        'التاريخ:   ${_reciteDate.toIso8601StringWithoutMilliseconds().toArabicNumbers()}',
                  ),
                  style: AppTextStyles.body(weight: .bold),
                  readOnly: true,
                  selectAllOnFocus: false,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      helpText: 'تاريخ التسميع',
                      barrierColor: Colors.black87,
                      currentDate: DateTime.now(),
                      locale: const Locale('ar', 'EG'),
                      textDirection: .rtl,
                      initialEntryMode: .calendarOnly,
                    );
                    if (date != null) _setRecitationDate(date);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewaya(QuranRewaya rewaya) {
    final isSelected = _rewaya == rewaya;

    return GestureDetector(
      onTap: () => _setRewaya(rewaya),
      child: AnimatedContainer(
        duration: 250.ms,
        margin: const .all(4),
        padding: const .symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green : AppColors.softContainer,
          borderRadius: .circular(4),
        ),
        child: Text(
          rewaya.arabicLabel,
          style: AppTextStyles.body(
            size: 16,
            weight: .bold,
            color: isSelected ? AppColors.softContainer : AppColors.indigo,
          ),
        ),
      ),
    );
  }

  Widget _buildSurah(SurahModel surah) {
    final isSelected = _surahNumber == surah.number;

    return GestureDetector(
      onTap: () => _setSurahNumber(surah.number),
      child: AnimatedContainer(
        duration: 250.ms,
        margin: const .all(4),
        padding: const .symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green : AppColors.softContainer,
          borderRadius: .circular(4),
        ),
        child: Text(
          surah.name,
          style: AppTextStyles.body(
            size: 16,
            weight: .bold,
            color: isSelected ? AppColors.softContainer : AppColors.indigo,
          ),
        ),
      ),
    );
  }

  Widget _buildPart(int part) {
    final isSelected = _qPart == part;

    return GestureDetector(
      onTap: () => _setQPart(part),
      child: AnimatedContainer(
        duration: 250.ms,
        margin: const .all(4),
        padding: const .symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green : AppColors.softContainer,
          borderRadius: .circular(4),
        ),
        child: Text(
          '$part'.toArabicNumbers(),
          style: AppTextStyles.body(
            size: 16,
            weight: .bold,
            color: isSelected ? AppColors.softContainer : AppColors.indigo,
          ),
        ),
      ),
    );
  }
}
