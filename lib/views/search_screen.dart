import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location_model.dart';
import '../themes/app_theme.dart';
import '../viewmodels/location_viewmodel.dart';
import '../widgets/dot_pattern.dart';
import '../widgets/location_card.dart';
import '../widgets/section_title.dart';
import '../widgets/weather_state.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<LocationModel> onLocationSelected;
  const SearchScreen({super.key, required this.onLocationSelected});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectLocation(LocationModel location) {
    FocusScope.of(context).unfocus();
    widget.onLocationSelected(location);
  }

  Future<void> _toggleFavorite(
    LocationViewModel vm,
    LocationModel location,
  ) async {
    final wasFavorite = vm.isFavorite(location);
    final success = await vm.toggleFavorite(location);
    if (!mounted) return;
    final message = success
        ? (wasFavorite
              ? '${location.name} dihapus dari favorit'
              : '${location.name} ditambahkan ke favorit')
        : 'Gagal memperbarui lokasi favorit';
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<LocationViewModel>(
    builder: (context, vm, child) => Scaffold(
      appBar: AppBar(
        title: Text('CARI LOKASI', style: AppTheme.dotText(fontSize: 28)),
      ),
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            right: 16,
            child: IgnorePointer(
              child: DotPattern(width: 110, height: 100, spacing: 10),
            ),
          ),
          const Positioned(
            bottom: 24,
            left: 16,
            child: IgnorePointer(
              child: DotPattern(width: 140, height: 100, spacing: 10),
            ),
          ),
          Positioned(
            right: -70,
            bottom: -70,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  onChanged: vm.onSearchChanged,
                  onSubmitted: vm.searchLocation,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari nama kota...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            tooltip: 'Hapus pencarian',
                            onPressed: () {
                              _controller.clear();
                              vm.clearSearch();
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppTheme.primary,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 26),
                Expanded(child: _body(vm)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget _body(LocationViewModel vm) {
    if (vm.query.isEmpty) return _favorites(vm);
    if (vm.query.length < 2) {
      return const WeatherState(
        icon: Icons.search_rounded,
        title: 'Cari Lokasi',
        message: 'Masukkan minimal 2 karakter nama kota',
      );
    }
    if (vm.isLoading) {
      return const WeatherState(
        icon: Icons.search,
        title: 'Mencari lokasi',
        message: 'Sedang mencari lokasi',
        isLoading: true,
      );
    }
    if (vm.errorMessage != null) {
      return WeatherState(
        icon: Icons.wifi_off,
        title: vm.errorMessage!,
        message: 'Periksa koneksi internet',
        buttonText: 'Coba Lagi',
        onPressed: () => vm.searchLocation(_controller.text),
      );
    }
    if (vm.locations.isEmpty) {
      return const WeatherState(
        icon: Icons.search_off,
        title: 'Lokasi tidak ditemukan',
        message: 'Coba gunakan kata kunci lainnya',
      );
    }
    return _list(vm, 'Hasil Pencarian', vm.locations);
  }

  Widget _favorites(LocationViewModel vm) {
    if (vm.isLoadingFavorites) {
      return const WeatherState(
        icon: Icons.star_border_rounded,
        title: 'Memuat favorit',
        message: 'Sedang mengambil lokasi tersimpan',
        isLoading: true,
      );
    }
    if (vm.favoriteError != null) {
      return WeatherState(
        icon: Icons.error_outline,
        title: vm.favoriteError!,
        message: 'Terjadi kesalahan saat membaca data',
        buttonText: 'Coba Lagi',
        onPressed: vm.loadFavorites,
      );
    }
    if (vm.favorites.isEmpty) {
      return const Column(
        children: [
          SectionTitle(title: 'Lokasi Favorit', trailing: '0 lokasi'),
          Expanded(
            child: WeatherState(
              icon: Icons.star_border_rounded,
              title: 'Belum ada favorit',
              message: 'Cari kota dan tekan ikon bintang untuk menyimpan lokasi favorit',
            ),
          ),
        ],
      );
    }
    return _list(vm, 'Lokasi Favorit', vm.favorites);
  }

  Widget _list(
    LocationViewModel vm,
    String title,
    List<LocationModel> locations,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SectionTitle(title: title, trailing: '${locations.length} lokasi'),
      if (vm.favoriteError != null)
        TextButton.icon(
          onPressed: vm.loadFavorites,
          icon: const Icon(Icons.refresh),
          label: const Text('Muat ulang data favorit'),
        ),
      const SizedBox(height: 16),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 28),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: locations.length,
          separatorBuilder: (_, index) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final location = locations[index];
            return LocationCard(
              location: location,
              isFavorite: vm.isFavorite(location),
              onTap: () => _selectLocation(location),
              onFavoritePressed:
                  vm.isSavingFavorites ||
                      vm.isLoadingFavorites ||
                      vm.favoriteError != null
                  ? null
                  : () => _toggleFavorite(vm, location),
            );
          },
        ),
      ),
    ],
  );
}
