import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'viewmodels/location_viewmodel.dart';
import 'themes/app_theme.dart';
import 'views/main_screen.dart';
import 'viewmodels/weather_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()..initialize()),
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
      ],
      child: const WeatherlyApp(),
    ),
  );
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
