import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = '25ccf416214b2132726c9461fa9b2a80';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherData> getWeatherByCity(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherData> getWeatherByLocation() async {
    Position position = await _getCurrentLocation();
    
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric'
      ),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

 Future<List<ForecastData>> getForecastByCity(String city) async {
  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _processForecastData(data);
    } else {
      throw Exception('Failed to load forecast data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getForecastByCity: $e');
    return [];
  }
}

  Future<List<ForecastData>> getForecastByLocation() async {
  try {
    Position position = await _getCurrentLocation();
    
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric'
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _processForecastData(data);
    } else {
      throw Exception('Failed to load forecast data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getForecastByLocation: $e');
    return [];
  }
}

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  Future<WeatherData> getWeatherByCoordinates(double lat, double lon) async {
  try {
    final url = Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    print('Fetching weather for coordinates: $lat, $lon');
    
    final response = await http.get(url);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getWeatherByCoordinates: $e');
    rethrow;
  }
}

Future<List<ForecastData>> getForecastByCoordinates(double lat, double lon) async {
  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _processForecastData(data);
    } else {
      throw Exception('Failed to load forecast data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getForecastByCoordinates: $e');
    return [];
  }
}

List<ForecastData> _processForecastData(Map<String, dynamic> data) {
  List<ForecastData> forecast = [];
  
  // Get one forecast per day (usually 8 forecasts per day, so take one per day)
  final dailyForecasts = <String, dynamic>{};
  
  for (var item in data['list']) {
    final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
    final dateKey = '${date.year}-${date.month}-${date.day}';
    
    // Only take one forecast per day (around midday if available)
    if (!dailyForecasts.containsKey(dateKey) || 
        (date.hour >= 10 && date.hour <= 14)) {
      dailyForecasts[dateKey] = item;
    }
  }
  
  // Convert to ForecastData objects and skip today
  final today = DateTime.now();
  final todayKey = '${today.year}-${today.month}-${today.day}';
  
  dailyForecasts.forEach((dateKey, item) {
    if (dateKey != todayKey) { // Skip today's forecast
      forecast.add(ForecastData.fromJson(item));
    }
  });
  
  // Return next 5 days
  return forecast.take(5).toList();
}

Future<Map<String, dynamic>> getCityCoordinates(String city) async {
  try {
    final url = Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'cityName': data['name'],
        'country': data['sys']['country'],
        'lat': data['coord']['lat'],
        'lon': data['coord']['lon'],
      };
    } else {
      throw Exception('Failed to get coordinates. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getCityCoordinates: $e');
    rethrow;
  }
}
}