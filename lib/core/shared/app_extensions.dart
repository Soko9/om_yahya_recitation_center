import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';

extension IntX on int {
  Duration get sec => Duration(seconds: this);
  Duration get ms => Duration(milliseconds: this);
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
