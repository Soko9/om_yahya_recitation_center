import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:om_yahya_recitation_center/app/screens/splash_screen.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/core/theme/app_theme.dart';

//> MAKE WEEKDAY PICKER DAYS COLORED

//> MAKE NEW TILE WIDGETS FOR EACH SECTION
//>> (TENANTS, RECITATION_BY_DATE, RECITATION_BY_TENANT)

//> MAKE CREATE TENANT BOTTOM SHEET

//> MAKE CREATE RECITATION BOTTOM SHEET

//> CENTERALIZE LOADING WIDGET

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
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
