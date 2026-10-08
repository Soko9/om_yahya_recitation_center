import 'dart:async';

import 'package:flutter/material.dart';
import 'package:om_yahya_recitation_center/app/screens/home_screen.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';
import 'package:om_yahya_recitation_center/core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(
      Future.delayed(2.sec, () async {
        if (!mounted) return;
        await context.pushReplace(const HomeScreen());
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const .all(32),
          child: FittedBox(
            fit: .fill,
            child: Text(
              'مقرأة أم\nيحيى',
              textAlign: .center,
              style: AppTextStyles.display(size: 200),
            ),
          ),
        ),
      ),
    );
  }
}
