import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_colors.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class WeekdayPicker extends StatelessWidget {
  const new({required this.selectedDate, required this.callback, super.key});

  final DateTime selectedDate;
  final void Function(DateTime date) callback;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final twoDaysAgo = today.subtract(2.day);
    final yesterDay = today.subtract(1.day);
    final tomorrow = today.add(1.day);
    final twoDaysLater = today.add(2.day);

    return Padding(
      padding: const .all(12),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => callback(twoDaysAgo),
              child: Container(
                alignment: .center,
                decoration: BoxDecoration(
                  color: (selectedDate.isEqual(twoDaysAgo))
                      ? AppColors.indigo.withValues(alpha: .1)
                      : Colors.transparent,
                  border: Border.all(
                    width: .45,
                    color: AppColors.indigo.withValues(alpha: .35),
                  ),
                  borderRadius: .circular(4),
                ),
                padding: const .symmetric(vertical: 4),
                child: _buildDateText(
                  twoDaysAgo.day,
                  twoDaysAgo.month,
                  AppTextStyles.body(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => callback(yesterDay),
              child: Container(
                alignment: .center,
                decoration: BoxDecoration(
                  color: (selectedDate.isEqual(yesterDay))
                      ? AppColors.indigo.withValues(alpha: .1)
                      : Colors.transparent,
                  border: Border.all(
                    width: .45,
                    color: AppColors.indigo.withValues(alpha: .35),
                  ),
                  borderRadius: .circular(4),
                ),
                padding: const .symmetric(vertical: 4),
                child: _buildDateText(
                  yesterDay.day,
                  yesterDay.month,
                  AppTextStyles.title(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () => callback(today),
              child: Container(
                alignment: .center,
                decoration: BoxDecoration(
                  color: (selectedDate.isEqual(today))
                      ? AppColors.indigo.withValues(alpha: .1)
                      : Colors.transparent,
                  border: Border.all(
                    width: .45,
                    color: AppColors.indigo.withValues(alpha: .35),
                  ),
                  borderRadius: .circular(4),
                ),
                padding: const .symmetric(vertical: 4),
                child: _buildDateText(
                  today.day,
                  today.month,
                  AppTextStyles.title(size: 48),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => callback(tomorrow),
              child: Container(
                alignment: .center,
                decoration: BoxDecoration(
                  color: (selectedDate.isEqual(tomorrow))
                      ? AppColors.indigo.withValues(alpha: .1)
                      : Colors.transparent,
                  border: Border.all(
                    width: .45,
                    color: AppColors.indigo.withValues(alpha: .35),
                  ),
                  borderRadius: .circular(4),
                ),
                padding: const .symmetric(vertical: 4),
                child: _buildDateText(
                  tomorrow.day,
                  tomorrow.month,
                  AppTextStyles.title(),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => callback(twoDaysLater),
              child: Container(
                alignment: .center,
                decoration: BoxDecoration(
                  color: (selectedDate.isEqual(twoDaysLater))
                      ? AppColors.indigo.withValues(alpha: .1)
                      : Colors.transparent,
                  border: Border.all(
                    width: .45,
                    color: AppColors.indigo.withValues(alpha: .35),
                  ),
                  borderRadius: .circular(4),
                ),
                padding: const .symmetric(vertical: 4),
                child: _buildDateText(
                  twoDaysLater.day,
                  twoDaysLater.month,
                  AppTextStyles.body(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateText(int day, int month, TextStyle style) {
    return RichText(
      textAlign: .center,
      text: TextSpan(
        text: '$day\n'.toArabicNumbers(),
        style: style,
        children: [
          TextSpan(
            text: '$month'.toArabicNumbers(),
            style: style.copyWith(fontSize: style.fontSize! * .45),
          ),
        ],
      ),
    );
  }
}
