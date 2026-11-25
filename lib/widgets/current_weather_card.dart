import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../themes/app_theme.dart';
import '../utils/weather_helper.dart';
import 'dot_weather_icon.dart';
import 'nothing_card.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const CurrentWeatherCard({super.key, required this.weather});
  @override
  Widget build(BuildContext context) {
    final today = weather.forecasts.isNotEmpty ? weather.forecasts.first : null;
    return NothingCard(
      radius: 28,
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 260;
          final icon = DotWeatherIcon(
            weatherCode: weather.weatherCode,
            size: compact ? 100 : 112,
          );
          final info = Column(
            crossAxisAlignment: compact
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${weather.temperature.round()}°C',
                  style: AppTheme.dotText(fontSize: 54),
                ),
              ),
              Text(
                WeatherHelper.getDescription(weather.weatherCode),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Terasa seperti ${weather.apparentTemperature.round()}°C',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          );
          return Column(
            children: [
              if (compact)
                Column(children: [icon, const SizedBox(height: 8), info])
              else
                Row(
                  children: [
                    icon,
                    Container(
                      width: 1,
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      color: AppTheme.border,
                    ),
                    Expanded(child: info),
                  ],
                ),
              if (today != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppTheme.primary,
                        size: 18,
                      ),
                      Text('${today.temperatureMax.round()}°C'),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.arrow_downward_rounded,
                        color: AppTheme.textSecondary,
                        size: 18,
                      ),
                      Text('${today.temperatureMin.round()}°C'),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
