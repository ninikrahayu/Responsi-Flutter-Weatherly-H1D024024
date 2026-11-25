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

  @override
  Widget build(BuildContext context) => Consumer<LocationViewModel>(
    builder: (context, vm, child) => Scaffold(
      appBar: AppBar(title: const Text('CARI LOKASI')),
      body: Stack(
        children: [
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
    if (vm.query.length < 2) {
      return const WeatherState(
        icon: Icons.location_on_outlined,
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
    return Column(
      children: [
        SectionTitle(
          title: 'Hasil Pencarian',
          trailing: '${vm.locations.length} lokasi',
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 28),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: vm.locations.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (_, index) => LocationCard(
              location: vm.locations[index],
              onTap: () => _selectLocation(vm.locations[index]),
            ),
          ),
        ),
      ],
    );
  }
}
