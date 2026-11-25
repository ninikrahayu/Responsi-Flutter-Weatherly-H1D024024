import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/geocoding_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final _weatherService = WeatherService();
  final _geocodingService = GeocodingService();
  LocationModel? _selectedLocation;
  WeatherModel? _weather;
  bool _isLoading = false, _disposed = false;
  String? _errorMessage;
  int _requestId = 0;
  LocationModel? get selectedLocation => _selectedLocation;
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> initialize() async {
    final requestId = ++_requestId;
    _isLoading = true;
    _errorMessage = null;
    _weather = null;
    notifyListeners();
    try {
      final locations = await _geocodingService.searchLocation('Yogyakarta');
      if (_disposed || requestId != _requestId) return;
      if (locations.isEmpty) {
        _selectedLocation = null;
        return;
      }
      _selectedLocation = locations.first;
      final result = await _weatherService.getWeather(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );
      if (_disposed || requestId != _requestId) return;
      _weather = result;
    } catch (e) {
      if (!_disposed && requestId == _requestId) {
        _errorMessage = 'Gagal memuat data cuaca';
      }
    } finally {
      if (!_disposed && requestId == _requestId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> selectLocation(LocationModel location) async {
    _selectedLocation = location;
    await fetchWeather();
  }

  Future<void> fetchWeather() async {
    final location = _selectedLocation;
    if (location == null) return;
    final requestId = ++_requestId;
    _isLoading = true;
    _errorMessage = null;
    _weather = null;
    notifyListeners();
    try {
      final result = await _weatherService.getWeather(
        location.latitude,
        location.longitude,
      );
      if (_disposed || requestId != _requestId) return;
      _weather = result;
    } catch (e) {
      if (!_disposed && requestId == _requestId) {
        _errorMessage = 'Gagal memuat data cuaca';
      }
    } finally {
      if (!_disposed && requestId == _requestId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> refreshWeather() async {
    if (_isLoading) return;
    if (_selectedLocation == null) {
      await initialize();
    } else {
      await fetchWeather();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
