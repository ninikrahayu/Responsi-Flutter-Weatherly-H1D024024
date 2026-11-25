class LocationModel {
  final int id;
  final String name, country, admin1;
  final double latitude, longitude;
  const LocationModel({
    required this.id,
    required this.name,
    required this.country,
    required this.admin1,
    required this.latitude,
    required this.longitude,
  });
  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: (json['id'] as num).toInt(),
    name: json['name'] as String,
    country: json['country'] as String? ?? '',
    admin1: json['admin1'] as String? ?? '',
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country,
    'admin1': admin1,
    'latitude': latitude,
    'longitude': longitude,
  };
  String get fullAddress =>
      [admin1, country].where((value) => value.isNotEmpty).join(', ');
}
