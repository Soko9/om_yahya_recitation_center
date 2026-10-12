// import 'package:flutter/material.dart';
// import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
// import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
// import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

// class WeekdayPicker extends StatelessWidget {
//   const new({required this.selectedDate, required this.callback, super.key});

//   final DateTime selectedDate;
//   final void Function(DateTime date) callback;

//   @override
//   Widget build(BuildContext context) {
//     final today = DateTime.now();
//     final yesterDay = today.subtract(1.day);
//     final twoDaysAgo = today.subtract(2.day);
//     final threeDaysAgo = today.subtract(3.day);
//     final fourDaysAgo = today.subtract(4.day);

//     return Padding(
//       padding: const .all(12),
//       child: Row(
//         spacing: 12,
//         children: [
//           Expanded(
//             child: InkWell(
//               onTap: () => callback(fourDaysAgo),
//               child: Container(
//                 alignment: .center,
//                 decoration: BoxDecoration(
//                   color: (selectedDate.isEqual(fourDaysAgo))
//                       ? AppColors.indigo.withValues(alpha: .1)
//                       : Colors.transparent,
//                   border: Border.all(
//                     width: (selectedDate.isEqual(fourDaysAgo)) ? 2 : .45,
//                     color: AppColors.indigo.withValues(alpha: .35),
//                   ),
//                   borderRadius: .circular(4),
//                 ),
//                 padding: const .symmetric(vertical: 4),
//                 child: _buildDateText(
//                   fourDaysAgo.day,
//                   fourDaysAgo.month,
//                   AppTextStyles.title(),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => callback(threeDaysAgo),
//               child: Container(
//                 alignment: .center,
//                 decoration: BoxDecoration(
//                   color: (selectedDate.isEqual(threeDaysAgo))
//                       ? AppColors.indigo.withValues(alpha: .1)
//                       : Colors.transparent,
//                   border: Border.all(
//                     width: (selectedDate.isEqual(threeDaysAgo)) ? 2 : .45,
//                     color: AppColors.indigo.withValues(alpha: .35),
//                   ),
//                   borderRadius: .circular(4),
//                 ),
//                 padding: const .symmetric(vertical: 4),
//                 child: _buildDateText(
//                   threeDaysAgo.day,
//                   threeDaysAgo.month,
//                   AppTextStyles.title(),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => callback(twoDaysAgo),
//               child: Container(
//                 alignment: .center,
//                 decoration: BoxDecoration(
//                   color: (selectedDate.isEqual(twoDaysAgo))
//                       ? AppColors.indigo.withValues(alpha: .1)
//                       : Colors.transparent,
//                   border: Border.all(
//                     width: (selectedDate.isEqual(twoDaysAgo)) ? 2 : .45,
//                     color: AppColors.indigo.withValues(alpha: .35),
//                   ),
//                   borderRadius: .circular(4),
//                 ),
//                 padding: const .symmetric(vertical: 4),
//                 child: _buildDateText(
//                   twoDaysAgo.day,
//                   twoDaysAgo.month,
//                   AppTextStyles.title(),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => callback(yesterDay),
//               child: Container(
//                 alignment: .center,
//                 decoration: BoxDecoration(
//                   color: (selectedDate.isEqual(yesterDay))
//                       ? AppColors.indigo.withValues(alpha: .1)
//                       : Colors.transparent,
//                   border: Border.all(
//                     width: (selectedDate.isEqual(yesterDay)) ? 2 : .45,
//                     color: AppColors.indigo.withValues(alpha: .35),
//                   ),
//                   borderRadius: .circular(4),
//                 ),
//                 padding: const .symmetric(vertical: 4),
//                 child: _buildDateText(
//                   yesterDay.day,
//                   yesterDay.month,
//                   AppTextStyles.title(),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: InkWell(
//               onTap: () => callback(today),
//               child: Container(
//                 alignment: .center,
//                 decoration: BoxDecoration(
//                   color: (selectedDate.isEqual(today))
//                       ? AppColors.green.withValues(alpha: .5)
//                       : AppColors.green.withValues(alpha: .15),
//                   border: Border.all(
//                     width: (selectedDate.isEqual(today)) ? 2 : .45,
//                     color: AppColors.indigo.withValues(alpha: .35),
//                   ),
//                   borderRadius: .circular(4),
//                 ),
//                 padding: const .symmetric(vertical: 4),
//                 child: _buildDateText(
//                   today.day,
//                   today.month,
//                   AppTextStyles.title(size: 48),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateText(int day, int month, TextStyle style) {
//     return RichText(
//       textAlign: .center,
//       text: TextSpan(
//         text: '$day\n'.toArabicNumbers(),
//         style: style,
//         children: [
//           TextSpan(
//             text: '$month'.toArabicNumbers(),
//             style: style.copyWith(fontSize: style.fontSize! * .45),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class WeekdayPicker extends StatelessWidget {
  const new({required this.selectedDate, required this.callback, super.key});

  final DateTime selectedDate;
  final ValueChanged<DateTime> callback;

  static const int _daysToShow = 5;
  static const double _spacing = 10;
  // static const double _borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final selected = DateUtils.dateOnly(selectedDate);

    final dates = List.generate(
      _daysToShow,
      (index) => today.subtract(Duration(days: _daysToShow - 1 - index)),
    );

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        spacing: _spacing,
        children: [
          for (final date in dates)
            Expanded(
              flex: DateUtils.isSameDay(date, today) ? 2 : 1,
              child: _DateTile(
                date: date,
                isSelected: DateUtils.isSameDay(date, selected),
                isToday: DateUtils.isSameDay(date, today),
                onTap: () => callback(date),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const new({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  static const double _radius = 4;

  @override
  Widget build(BuildContext context) {
    final weekday = date.weekday.weekday;

    final accentColor = isToday ? AppColors.green : AppColors.indigo;

    final backgroundColor = isSelected
        ? accentColor.withValues(alpha: 0.16)
        : isToday
        ? AppColors.indigo.withValues(alpha: 0.08)
        : Colors.transparent;

    final borderColor = isSelected
        ? accentColor
        : AppColors.indigo.withValues(alpha: 0.18);

    const textColor = AppColors.indigo;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${date.day}/${date.month}/${date.year}'.toArabicNumbers(),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(_radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_radius),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2.6 : 0.8,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weekday,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: AppTextStyles.title(
                    size: 11,
                    color: textColor.withValues(alpha: 0.7),
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date.day.toString().toArabicNumbers(),
                  style: AppTextStyles.title(
                    size: isToday ? 34 : 24,
                    weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ).copyWith(height: 1.1),
                ),
                const SizedBox(height: 4),
                Text(
                  date.month.toString().toArabicNumbers(),
                  style: AppTextStyles.title(
                    size: 12,
                    color: textColor.withValues(alpha: 0.7),
                    weight: FontWeight.w500,
                  ),
                ),
                if (isToday) ...[
                  const SizedBox(height: 5),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
