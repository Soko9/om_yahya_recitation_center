import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:om_yahya_recitation_center/app/screens/splash_screen.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/core/theme/app_theme.dart';

//? v1.1.0
//* CHECK FONT ON RELEASE
//* CHECK FILE EXTENSION .APK ON GITHUB RELEASE
//* CHANGE THE DISPLAY NAME OF THE APP
//* ADD NOTES FOR RECITATION
//* ADD DELETE FOR TENANTS AND RECITATIONS
//. ADD AUTO-DELETE FOR RECITATION BEFORE 5 DAYS

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DbService.init();
  // await DbService.clearDb();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Om Yahya Recitation Center',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
