import 'package:flutter_test/flutter_test.dart';
import 'package:weatherly/models/location_model.dart';

void main() {
  final json = {
    'id': 1,
    'name': 'Yogyakarta',
    'country': 'Indonesia',
    'admin1': 'DI Yogyakarta',
    'latitude': -7.8,
    'longitude': 110.36,
  };
  group('LocationModel', () {
    test('Berhasil mengubah JSON menjadi LocationModel', () {
      final location = LocationModel.fromJson(json);
      expect(location.id, 1);
      expect(location.name, 'Yogyakarta');
      expect(location.country, 'Indonesia');
      expect(location.admin1, 'DI Yogyakarta');
      expect(location.latitude, -7.8);
      expect(location.longitude, 110.36);
    });
    test('Berhasil mengubah LocationModel menjadi JSON', () {
      expect(LocationModel.fromJson(json).toJson(), json);
    });
    test('Berhasil menghasilkan alamat lengkap', () {
      expect(
        LocationModel.fromJson(json).fullAddress,
        'DI Yogyakarta, Indonesia',
      );
    });
  });
}
