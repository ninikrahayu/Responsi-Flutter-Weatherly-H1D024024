import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherly/models/location_model.dart';
import 'package:weatherly/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late StorageService storageService;
  const location = LocationModel(
    id: 1,
    name: 'Yogyakarta',
    country: 'Indonesia',
    admin1: 'DI Yogyakarta',
    latitude: -7.8,
    longitude: 110.36,
  );
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storageService = StorageService();
  });
  group('StorageService', () {
    test('Daftar favorit awal kosong', () async {
      expect(await storageService.getFavorites(), isEmpty);
    });
    test('Berhasil menyimpan lokasi favorit', () async {
      await storageService.saveFavorites([location]);
      final favorites = await storageService.getFavorites();
      expect(favorites.length, 1);
      expect(favorites.first.name, 'Yogyakarta');
      expect(favorites.first.id, 1);
    });
    test('Berhasil menghapus lokasi favorit', () async {
      await storageService.saveFavorites([location]);
      await storageService.saveFavorites([]);
      expect(await storageService.getFavorites(), isEmpty);
    });
    test('Data dapat dibaca melalui instance service baru', () async {
      await storageService.saveFavorites([location]);
      final favorites = await StorageService().getFavorites();
      expect(favorites.length, 1);
      expect(favorites.first.toJson(), location.toJson());
    });
  });
}
