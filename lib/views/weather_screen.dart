import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/dot_pattern.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/weather_detail_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/section_title.dart';
import '../widgets/weather_state.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});
  @override
  Widget build(BuildContext context) => Consumer<WeatherViewModel>(
    builder: (context, vm, child) => Scaffold(
      appBar: AppBar(
        title: Text('CUACA', style: AppTheme.dotText(fontSize: 30)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton.outlined(
              tooltip: 'Muat ulang',
              onPressed: vm.isLoading ? null : vm.refreshWeather,
              icon: const Icon(Icons.refresh_rounded),
            ),
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
        message: 'Sedang mengambil informasi cuaca terbaru',
        isLoading: true,
      );
    }
    if (vm.errorMessage != null) {
      return WeatherState(
        icon: Icons.wifi_off,
        title: vm.errorMessage!,
        message: 'Periksa koneksi internet dan coba kembali',
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
    final probability = weather.forecasts.isEmpty
        ? '-'
        : '${weather.forecasts.first.precipitationProbability}%';
    return Stack(
      children: [
        const Positioned(
          top: 4,
          right: 16,
          child: IgnorePointer(
            child: DotPattern(width: 110, height: 100, spacing: 10),
          ),
        ),
        Positioned(
          top: 80,
          right: -65,
          child: IgnorePointer(
            child: Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: vm.refreshWeather,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, size: 11, color: AppTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 21),
                child: Text(
                  location.fullAddress,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              CurrentWeatherCard(weather: weather),
              const SizedBox(height: 26),
              const SectionTitle(title: 'Detail Cuaca'),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) => GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth >= 650 ? 4 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 110,
                  ),
                  children: [
                    WeatherDetailCard(
                      title: 'Kelembapan',
                      value: '${weather.humidity}%',
                      icon: Icons.water_drop_outlined,
                    ),
                    WeatherDetailCard(
                      title: 'Kecepatan Angin',
                      value: '${weather.windSpeed.toStringAsFixed(1)} km/j',
                      icon: Icons.air_rounded,
                    ),
                    WeatherDetailCard(
                      title: 'Curah Hujan',
                      value: '${weather.precipitation.toStringAsFixed(1)} mm',
                      icon: Icons.grain_rounded,
                    ),
                    WeatherDetailCard(
                      title: 'Peluang Hujan',
                      value: probability,
                      icon: Icons.umbrella_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              SectionTitle(title: 'Prakiraan ${weather.forecasts.length} Hari'),
              const SizedBox(height: 14),
              if (weather.forecasts.isEmpty)
                const Text('Prakiraan cuaca belum tersedia')
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      weather.forecasts.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          right: index == weather.forecasts.length - 1 ? 0 : 10,
                        ),
                        child: ForecastCard(
                          forecast: weather.forecasts[index],
                          isToday: index == 0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
