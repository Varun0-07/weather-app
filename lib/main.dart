import 'package:flutter/material.dart';
import 'package:weather_app/screens/welcome_screen.dart';
import 'package:weather_app/screens/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AppWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _showWelcomeScreen = true;

  void _handleAnimationComplete() {
    setState(() {
      _showWelcomeScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showWelcomeScreen
        ? WelcomeScreen(onAnimationComplete: _handleAnimationComplete)
        : const WeatherScreen();
  }
}