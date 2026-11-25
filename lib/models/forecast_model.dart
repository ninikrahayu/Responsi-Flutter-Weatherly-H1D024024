class ForecastModel {
  final DateTime date;
  final double temperatureMax, temperatureMin;
  final int precipitationProbability, weatherCode;
  const ForecastModel({
    required this.date,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationProbability,
    required this.weatherCode,
  });
  factory ForecastModel.fromJson(Map<String, dynamic> json, int index) =>
      ForecastModel(
        date: DateTime.parse(json['time'][index]),
        temperatureMax: (json['temperature_2m_max'][index] as num).toDouble(),
        temperatureMin: (json['temperature_2m_min'][index] as num).toDouble(),
        precipitationProbability:
            (json['precipitation_probability_max'][index] as num).toInt(),
        weatherCode: (json['weather_code'][index] as num).toInt(),
      );
}
