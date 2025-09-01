import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/background_helper.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final textColor = BackgroundHelper.getTextColor(weatherData.mainCondition);

    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    if (weatherData.cityName == 'Current Location')
      const Icon(Icons.my_location, size: 16, color: Colors.white70),
    Text(
      weatherData.cityName,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),
  ],
),
            Text(
              '${weatherData.cityName}, ${weatherData.country}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Image.network(
              'https://openweathermap.org/img/wn/${weatherData.icon}@4x.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 16),
            Text(
              '${weatherData.temperature.round()}°C',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weatherData.description.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                color: textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Feels like ${weatherData.feelsLike.round()}°C',
              style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}