import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class ForecastWidget extends StatelessWidget {
  final List<ForecastData> forecastData;

  const ForecastWidget({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    if (forecastData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            '5-Day Forecast',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.8,
          ),
          itemCount: forecastData.length,
          itemBuilder: (context, index) {
            final forecast = forecastData[index];
            return _buildForecastCard(forecast);
          },
        ),
      ],
    );
  }

  Widget _buildForecastCard(ForecastData forecast) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(251, 255, 255, 255).withOpacity(0.20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getDayName(forecast.date.weekday),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${forecast.date.day}/${forecast.date.month}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Image.network(
              'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.wb_sunny, color: Colors.white, size: 30);
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${forecast.temperature.round()}°C',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${forecast.minTemp.round()}°/${forecast.maxTemp.round()}°',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}