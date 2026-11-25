import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location_model.dart';

class GeocodingService {
  Future<List<LocationModel>> searchLocation(String query) async {
    if (query.trim().length < 2) return [];
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query.trim(),
      'count': '10',
      'language': 'id',
      'format': 'json',
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) throw Exception('Gagal mencari lokasi');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
