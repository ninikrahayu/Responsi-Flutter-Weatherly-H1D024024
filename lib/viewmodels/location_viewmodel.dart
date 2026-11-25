import 'dart:async';

import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../services/geocoding_service.dart';
import '../services/storage_service.dart';

class LocationViewModel extends ChangeNotifier {
  final _geocodingService = GeocodingService();
  final _storageService = StorageService();
  List<LocationModel> _locations = [], _favorites = [];
  bool _isLoading = false,
      _isLoadingFavorites = false,
      _isSavingFavorites = false,
      _disposed = false;
  String? _errorMessage, _favoriteError;
  String _query = '';
  Timer? _debounce;
  int _requestId = 0;
  List<LocationModel> get locations => List.unmodifiable(_locations);
  List<LocationModel> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  bool get isLoadingFavorites => _isLoadingFavorites;
  bool get isSavingFavorites => _isSavingFavorites;
  String? get errorMessage => _errorMessage;
  String? get favoriteError => _favoriteError;
  String get query => _query;
  Future<void> loadFavorites() async {
    if (_disposed || _isLoadingFavorites || _isSavingFavorites) return;
    _isLoadingFavorites = true;
    _favoriteError = null;
    notifyListeners();
    try {
      final result = await _storageService.getFavorites();
      if (_disposed) return;
      _favorites = result;
    } catch (e) {
      if (!_disposed) _favoriteError = 'Gagal memuat lokasi favorit';
    } finally {
      if (!_disposed) {
        _isLoadingFavorites = false;
        notifyListeners();
      }
    }
  }

  bool isFavorite(LocationModel location) =>
      _favorites.any((item) => item.id == location.id);
  Future<bool> toggleFavorite(LocationModel location) async {
    if (_disposed ||
        _isSavingFavorites ||
        _isLoadingFavorites ||
        _favoriteError != null) {
      return false;
    }
    _isSavingFavorites = true;
    notifyListeners();
    final updated = List<LocationModel>.from(_favorites);
    if (isFavorite(location)) {
      updated.removeWhere((item) => item.id == location.id);
    } else {
      updated.add(location);
    }
    try {
      await _storageService.saveFavorites(updated);
      if (_disposed) return false;
      _favorites = updated;
      return true;
    } catch (e) {
      return false;
    } finally {
      if (!_disposed) {
        _isSavingFavorites = false;
        notifyListeners();
      }
    }
  }

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
