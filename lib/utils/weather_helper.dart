import 'package:flutter/material.dart';

class WeatherHelper {
  static String getDescription(int code) {
    switch (code) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Cerah Berawan';
      case 2:
        return 'Berawan Sebagian';
      case 3:
        return 'Berawan';
      case 45:
      case 48:
        return 'Berkabut';
      case 51:
      case 53:
      case 55:
        return 'Gerimis';
      case 56:
      case 57:
        return 'Gerimis Beku';
      case 61:
        return 'Hujan Ringan';
      case 63:
        return 'Hujan Sedang';
      case 65:
        return 'Hujan Lebat';
      case 66:
      case 67:
        return 'Hujan Beku';
      case 71:
      case 73:
      case 75:
      case 77:
        return 'Salju';
      case 80:
        return 'Hujan Lokal Ringan';
      case 81:
        return 'Hujan Lokal Sedang';
      case 82:
        return 'Hujan Lokal Lebat';
      case 85:
      case 86:
        return 'Hujan Salju';
      case 95:
      case 96:
      case 99:
        return 'Badai Petir';
      default:
        return 'Tidak Diketahui';
    }
  }

  static IconData getIcon(int code) {
    if (code == 0) return Icons.wb_sunny_outlined;
    if ([1, 2, 3].contains(code)) return Icons.cloud_outlined;
    if ([45, 48].contains(code)) return Icons.foggy;
    if ([51, 53, 55, 56, 57].contains(code)) return Icons.grain_rounded;
    if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code)) {
      return Icons.water_drop_outlined;
    }
    if ([71, 73, 75, 77, 85, 86].contains(code)) return Icons.ac_unit_rounded;
    if ([95, 96, 99].contains(code)) return Icons.thunderstorm_outlined;
    return Icons.cloud_off_outlined;
  }
}
