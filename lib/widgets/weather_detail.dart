import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetails extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetails({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3, // Reduced from 1.5 to fit better
            crossAxisSpacing: 12, // Reduced spacing
            mainAxisSpacing: 12,  // Reduced spacing
            padding: const EdgeInsets.symmetric(horizontal: 8), // Added padding
            children: [
              _buildDetailCard('Humidity', '${weatherData.humidity}%', Icons.water_drop),
              _buildDetailCard('Wind Speed', '${weatherData.windSpeed} m/s', Icons.air),
              _buildDetailCard('Pressure', '${weatherData.pressure} hPa', Icons.speed),
              _buildDetailCard('Updated', _formatTime(weatherData.lastUpdated), Icons.access_time),
            ],
          ),
          const SizedBox(height: 16), // Add some bottom padding
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero, // Remove default margin
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.blue), // Smaller icon
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.black), // Smaller font
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}