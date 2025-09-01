import 'package:flutter/material.dart';

class BackgroundHelper {
  static LinearGradient getWeatherGradient(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF47AB2F), Color(0xFFB7F4A6)],
        );
      case 'clouds':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF54717A), Color(0xFFB7C6CD)],
        );
      case 'rain':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF57575D), Color(0xFF94A0B0)],
        );
      case 'snow':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF83A4D4), Color(0xFFB6FBFF)],
        );
      case 'thunderstorm':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF373B44), Color(0xFF6D7B8C)],
        );
      case 'drizzle':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF616161), Color(0xFF9BC5C3)],
        );
      case 'mist':
      case 'fog':
      case 'haze':
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF7F7F7F), Color(0xFFC0C0C0)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
        );
    }
  }

  static String getWeatherImage(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return 'assets/images/sunny_bg.png';
      case 'clouds':
        return 'assets/images/cloudy_bg.png';
      case 'rain':
        return 'assets/images/rainy_bg.png';
      case 'snow':
        return 'assets/images/snowy_bg.png';
      case 'thunderstorm':
        return 'assets/images/storm_bg.png';
      default:
        return 'assets/images/default_bg.png';
    }
  }

  static Color getTextColor(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'snow':
      case 'clouds':
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}