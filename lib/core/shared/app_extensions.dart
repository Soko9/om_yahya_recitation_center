import 'package:flutter/material.dart';

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
