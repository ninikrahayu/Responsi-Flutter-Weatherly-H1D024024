import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import 'weather_screen.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _selectedIndex,
      children: const [WeatherScreen(), SearchScreen()],
    ),
    bottomNavigationBar: Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.textPrimary)),
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          FocusScope.of(context).unfocus();
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_cloudy_outlined),
            selectedIcon: Icon(Icons.wb_cloudy, color: AppTheme.primary),
            label: 'Cuaca',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: AppTheme.primary),
            label: 'Cari Lokasi',
          ),
        ],
      ),
    ),
  );
}
