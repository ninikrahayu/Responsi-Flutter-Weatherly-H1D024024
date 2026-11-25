import 'package:flutter/material.dart';

import '../themes/app_theme.dart';
import '../widgets/nothing_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('CUACA')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: NothingCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wb_cloudy_outlined,
                size: 80,
                color: AppTheme.primary,
              ),
              Text('WEATHERLY', style: AppTheme.dotText(fontSize: 32)),
              const Text(
                'Informasi cuaca akan ditampilkan di sini',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
