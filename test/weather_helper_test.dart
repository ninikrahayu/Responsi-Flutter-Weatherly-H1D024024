import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/utils/weather_helper.dart';

void main() {
  group('WeatherHelper', () {
    test(
      'Kode 0 menghasilkan kondisi cerah',
      () => expect(WeatherHelper.getDescription(0), 'Cerah'),
    );
    test(
      'Kode 3 menghasilkan kondisi berawan',
      () => expect(WeatherHelper.getDescription(3), 'Berawan'),
    );
    test(
      'Kode 61 menghasilkan kondisi hujan ringan',
      () => expect(WeatherHelper.getDescription(61), 'Hujan Ringan'),
    );
    test(
      'Kode 95 menghasilkan kondisi badai petir',
      () => expect(WeatherHelper.getDescription(95), 'Badai Petir'),
    );
    test(
      'Kode tidak valid menghasilkan kondisi tidak diketahui',
      () => expect(WeatherHelper.getDescription(999), 'Tidak Diketahui'),
    );
  });
}
