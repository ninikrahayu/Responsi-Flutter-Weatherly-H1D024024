import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/forecast_model.dart';
import '../themes/app_theme.dart';
import '../utils/weather_helper.dart';
import 'dot_weather_icon.dart';
import 'nothing_card.dart';

class ForecastCard extends StatelessWidget {
  final ForecastModel forecast;
  final bool isToday;
  const ForecastCard({super.key, required this.forecast, this.isToday = false});
  @override
  Widget build(BuildContext context) {
    final color = isToday ? Colors.white : AppTheme.textPrimary;
    final secondary = isToday ? Colors.white70 : AppTheme.textSecondary;
    return SizedBox(
      width: 88,
      child: NothingCard(
        radius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        backgroundColor: isToday ? AppTheme.primary : AppTheme.surface,
        borderColor: isToday ? AppTheme.primary : AppTheme.textPrimary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isToday
                  ? 'Hari ini'
                  : DateFormat('EEE', 'id_ID').format(forecast.date),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(
              DateFormat('dd MMM', 'id_ID').format(forecast.date),
              style: TextStyle(fontSize: 10, color: secondary),
            ),
            const SizedBox(height: 8),
            DotWeatherIcon(
              weatherCode: forecast.weatherCode,
              size: 48,
              color: color,
              accentColor: isToday ? Colors.white : AppTheme.primary,
            ),
            const SizedBox(height: 6),
            Tooltip(
              message: WeatherHelper.getDescription(forecast.weatherCode),
              child: FittedBox(
                child: Text(
                  '${forecast.temperatureMax.round()}°/${forecast.temperatureMin.round()}°',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  size: 12,
                  color: isToday ? Colors.white : AppTheme.primary,
                ),
                const SizedBox(width: 3),
                Text(
                  '${forecast.precipitationProbability}%',
                  style: TextStyle(fontSize: 11, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
