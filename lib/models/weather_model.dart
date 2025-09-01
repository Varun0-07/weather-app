class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final String description;
  final String icon;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final DateTime lastUpdated;
  final String mainCondition;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.lastUpdated,
    required this.mainCondition,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      description: (json['weather'][0]['description'] ?? '').toString(),
      icon: json['weather'][0]['icon'] ?? '01d',
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      lastUpdated: DateTime.now(),
      mainCondition: json['weather'][0]['main'] ?? 'Clear',
    );
  }
}

class ForecastData {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;
  final String mainCondition;
  final double minTemp;
  final double maxTemp;

  ForecastData({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.minTemp,
    required this.maxTemp,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      description: (json['weather'][0]['description'] ?? '').toString(),
      icon: json['weather'][0]['icon'] ?? '01d',
      mainCondition: json['weather'][0]['main'] ?? 'Clear',
      minTemp: (json['main']['temp_min'] ?? 0).toDouble(),
      maxTemp: (json['main']['temp_max'] ?? 0).toDouble(),
    );
  }
}