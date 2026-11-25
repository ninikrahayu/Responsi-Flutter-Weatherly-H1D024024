import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> getWeather(double latitude, double longitude) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'daily': 'temperature_2m_max,temperature_2m_min,precipitation_probability_max,weather_code',
      'timezone': 'auto',
      'forecast_days': '5',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data cuaca');
    }

    return WeatherModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
