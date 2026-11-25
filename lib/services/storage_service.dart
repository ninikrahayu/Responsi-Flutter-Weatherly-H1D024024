import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_model.dart';

class StorageService {
  static const _favoritesKey = 'favorite_locations';
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_favoritesKey);
    if (data == null || data.isEmpty) return [];
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded
        .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFavorites(List<LocationModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString(
      _favoritesKey,
      jsonEncode(favorites.map((location) => location.toJson()).toList()),
    );
    if (!success) throw Exception('Gagal menyimpan lokasi favorit');
  }
}
