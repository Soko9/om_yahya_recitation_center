import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:om_yahya_recitation_center/app/screens/splash_screen.dart';
import 'package:om_yahya_recitation_center/app/services/db_service.dart';
import 'package:om_yahya_recitation_center/core/theme/app_theme.dart';

//? v1.2.0
//* FIX CHANGING SURAH WITH FINISHING NUMBER OF VERSES
//* LOAD WHEN POPPING BACK
//* MAKE VERSE FIELD SELECTABLE ON FOCUS AND MAKE THE INITIAL NUMBER OF START [1]
//* FIX DELETING RECITATIONS
//* ADD NOTES ON RECITATION TILE
//* LOCK APP ON PORTRAIT MODE
//* SHOW NEWER RECITATION FIRST IN HOME SCREEN

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
