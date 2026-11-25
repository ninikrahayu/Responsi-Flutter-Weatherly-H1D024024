import 'forecast_model.dart';

class WeatherModel {
  final double temperature, apparentTemperature, precipitation, windSpeed;
  final int humidity, weatherCode;
  final List<ForecastModel> forecasts;
  const WeatherModel({
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.forecasts,
  });
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    final dates = daily['time'] as List<dynamic>;
    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      precipitation: (current['precipitation'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      forecasts: List.generate(
        dates.length,
        (index) => ForecastModel.fromJson(daily, index),
      ),
    );
  }
}
