import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .25,
      margin: const .only(top: 6, bottom: 4, left: 12, right: 12),
      color: Colors.black54,
    );
  }
}
