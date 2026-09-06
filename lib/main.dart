
import 'package:flutter/material.dart' show WidgetsFlutterBinding, Colors, runApp, StatelessWidget, Widget, BuildContext, MaterialApp;
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation, SystemUiOverlayStyle, Brightness;
import 'package:stegacrypt/theme/app_theme.dart' show AppTheme;
import 'package:stegacrypt/views/splash_screen.dart' show SplashScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StegaCrypt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
