import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/models/weather_model.dart';

void main() {
  final json = {
    'current': {
      'temperature_2m': 28.5,
      'relative_humidity_2m': 75,
      'apparent_temperature': 30.2,
      'precipitation': 0.2,
      'weather_code': 2,
      'wind_speed_10m': 12.5,
    },
    'daily': {
      'time': ['2026-11-25', '2026-11-26'],
      'temperature_2m_max': [32.0, 31.0],
      'temperature_2m_min': [25.0, 24.0],
      'precipitation_probability_max': [20, 60],
      'weather_code': [2, 61],
    },
  };
  group('WeatherModel', () {
    test('Berhasil melakukan parsing data cuaca', () {
      final weather = WeatherModel.fromJson(json);
      expect(weather.temperature, 28.5);
      expect(weather.humidity, 75);
      expect(weather.apparentTemperature, 30.2);
      expect(weather.precipitation, 0.2);
      expect(weather.weatherCode, 2);
      expect(weather.windSpeed, 12.5);
    });
    test('Berhasil melakukan parsing prakiraan cuaca', () {
      final weather = WeatherModel.fromJson(json);
      expect(weather.forecasts.length, 2);
      expect(weather.forecasts.first.temperatureMax, 32.0);
      expect(weather.forecasts.first.temperatureMin, 25.0);
      expect(weather.forecasts.first.precipitationProbability, 20);
      expect(weather.forecasts.last.weatherCode, 61);
    });
    test('Berhasil melakukan parsing tanggal prakiraan', () {
      expect(
        WeatherModel.fromJson(json).forecasts.first.date,
        DateTime(2026, 11, 25),
      );
    });
  });
}
