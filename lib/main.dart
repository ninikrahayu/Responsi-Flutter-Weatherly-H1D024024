import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'themes/app_theme.dart';
import 'views/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const WeatherlyApp());
}

class WeatherlyApp extends StatelessWidget {
  const WeatherlyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Weatherly',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const MainScreen(),
  );
}
