import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../utils/weather_helper.dart';
import '../widgets/nothing_card.dart';
import '../widgets/weather_state.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});
  @override
  Widget build(BuildContext context) => Consumer<WeatherViewModel>(
    builder: (context, vm, child) => Scaffold(
      appBar: AppBar(
        title: const Text('CUACA'),
        actions: [
          IconButton(
            onPressed: vm.isLoading ? null : vm.refreshWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _body(vm),
    ),
  );
  Widget _body(WeatherViewModel vm) {
    if (vm.isLoading) {
      return const WeatherState(
        icon: Icons.cloud_outlined,
        title: 'Memuat data',
        message: 'Mengambil informasi cuaca',
        isLoading: true,
      );
    }
    if (vm.errorMessage != null) {
      return WeatherState(
        icon: Icons.wifi_off,
        title: vm.errorMessage!,
        message: 'Periksa koneksi internet',
        buttonText: 'Coba Lagi',
        onPressed: vm.refreshWeather,
      );
    }
    final weather = vm.weather;
    final location = vm.selectedLocation;
    if (weather == null || location == null) {
      return WeatherState(
        icon: Icons.cloud_off_outlined,
        title: 'Data tidak ditemukan',
        message: 'Belum ada informasi cuaca',
        buttonText: 'Muat Ulang',
        onPressed: vm.refreshWeather,
      );
    }
    return RefreshIndicator(
      onRefresh: vm.refreshWeather,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            location.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(location.fullAddress),
          const SizedBox(height: 20),
          NothingCard(
            child: Column(
              children: [
                Icon(
                  WeatherHelper.getIcon(weather.weatherCode),
                  size: 90,
                  color: AppTheme.primary,
                ),
                Text(
                  '${weather.temperature.round()}°C',
                  style: AppTheme.dotText(fontSize: 54),
                ),
                Text(WeatherHelper.getDescription(weather.weatherCode)),
                Text('Terasa seperti ${weather.apparentTemperature.round()}°C'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          NothingCard(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Kelembapan'),
                  trailing: Text('${weather.humidity}%'),
                ),
                ListTile(
                  title: const Text('Angin'),
                  trailing: Text('${weather.windSpeed} km/j'),
                ),
                ListTile(
                  title: const Text('Curah Hujan'),
                  trailing: Text('${weather.precipitation} mm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
