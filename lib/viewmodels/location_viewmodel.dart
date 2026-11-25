import 'dart:async';

import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../services/geocoding_service.dart';

class LocationViewModel extends ChangeNotifier {
  final _geocodingService = GeocodingService();
  List<LocationModel> _locations = [];
  bool _isLoading = false, _disposed = false;
  String? _errorMessage;
  String _query = '';
  Timer? _debounce;
  int _requestId = 0;
  List<LocationModel> get locations => List.unmodifiable(_locations);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get query => _query;
  void onSearchChanged(String value) {
    _debounce?.cancel();
    _requestId++;
    _query = value.trim();
    _errorMessage = null;
    _locations = [];
    _isLoading = _query.length >= 2;
    notifyListeners();
    if (_isLoading) {
      _debounce = Timer(
        const Duration(milliseconds: 500),
        () => searchLocation(_query),
      );
    }
  }

  Future<void> searchLocation(String value) async {
    _debounce?.cancel();
    final requestId = ++_requestId;
    _query = value.trim();
    _errorMessage = null;
    _locations = [];
    _isLoading = _query.length >= 2;
    notifyListeners();
    if (!_isLoading) return;
    try {
      final results = await _geocodingService.searchLocation(_query);
      if (_disposed || requestId != _requestId) return;
      _locations = results;
    } catch (e) {
      if (!_disposed && requestId == _requestId) {
        _errorMessage = 'Gagal mencari lokasi';
      }
    } finally {
      if (!_disposed && requestId == _requestId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void clearSearch() => onSearchChanged('');
  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
