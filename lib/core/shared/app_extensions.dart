import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/recitation_model.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';

extension IntX on int {
  Duration get sec => Duration(seconds: this);
  Duration get ms => Duration(milliseconds: this);
  Duration get day => Duration(days: this);
}

extension ContextX on BuildContext {
  Future<void> push(Widget screen) =>
      Navigator.of(this)
          .push(MaterialPageRoute<dynamic>(builder: (_) => screen));

  Future<void> pushReplace(Widget screen) =>
      Navigator.of(this)
          .pushReplacement(MaterialPageRoute<dynamic>(builder: (_) => screen));

  void pop() => Navigator.of(this).pop();
}

extension DateTimeX on DateTime {
  String toIso8601StringWithoutMilliseconds() {
    return toIso8601String().split('T').first.replaceAll('-', '/');
  }

  bool isEqual(DateTime other) => day == other.day && month == other.month;

  static DateTime parse(String str) => DateTime(
    int.parse(str.split('/')[0]),
    int.parse(str.split('/')[1]),
    int.parse(str.split('/')[2]),
  );
}

extension TenantX on TenantModel {
  String get fullName => '$firstName $middleName $lastName';
}

extension StringX on String {
  String toArabicNumbers() {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return replaceAllMapped(
      RegExp('[0-9]'),
      (match) => arabicDigits[int.parse(match.group(0)!)],
    );
  }
}

extension QuranRewayaExtension on QuranRewaya {
  String get arabicLabel {
    switch (this) {
      case QuranRewaya.hafsAnAsim:
        return 'حفص عن عاصم';

      case QuranRewaya.shubahAnAsim:
        return 'شعبة عن عاصم';

      case QuranRewaya.warshAnNafi:
        return 'ورش عن نافع';

      case QuranRewaya.qalunAnNafi:
        return 'قالون عن نافع';

      case QuranRewaya.alDuriAnAbiAmr:
        return 'الدوري عن أبي عمرو';

      case QuranRewaya.alSusiAnAbiAmr:
        return 'السوسي عن أبي عمرو';

      case QuranRewaya.alBaziiAnIbnKathir:
        return 'البزي عن ابن كثير';

      case QuranRewaya.qunbulAnIbnKathir:
        return 'قنبل عن ابن كثير';

      case QuranRewaya.hishamAnIbnAmir:
        return 'هشام عن ابن عامر';

      case QuranRewaya.ibnDhakwanAnIbnAmir:
        return 'ابن ذكوان عن ابن عامر';

      case QuranRewaya.shuabahAnHamzah:
        return 'خلاد عن حمزة';

      case QuranRewaya.khalafAnHamzah:
        return 'خلف عن حمزة';

      case QuranRewaya.abuAlHarithAnAlKisai:
        return 'أبو الحارث عن الكسائي';

      case QuranRewaya.alDuriAnAlKisai:
        return 'الدوري عن الكسائي';

      case QuranRewaya.ibnWardanAnAbiJafar:
        return 'ابن وردان عن أبي جعفر';

      case QuranRewaya.ibnJammazAnAbiJafar:
        return 'ابن جماز عن أبي جعفر';

      case QuranRewaya.alBaziiAnYaqub:
        return 'رويس عن يعقوب';

      case QuranRewaya.rawhAnYaqub:
        return 'روح عن يعقوب';

      case QuranRewaya.ishaqAnKhalaf:
        return 'إسحاق عن خلف';

      case QuranRewaya.idrisAnKhalaf:
        return 'إدريس عن خلف';
    }
  }

  String get value => name;

  static QuranRewaya? fromString(String value) {
    for (final rewaya in QuranRewaya.values) {
      if (rewaya.name == value) {
        return rewaya;
      }
    }

    return null;
  }

  static QuranRewaya? fromArabicLabel(String label) {
    for (final rewaya in QuranRewaya.values) {
      if (rewaya.arabicLabel == label) {
        return rewaya;
      }
    }

    return null;
  }
}
