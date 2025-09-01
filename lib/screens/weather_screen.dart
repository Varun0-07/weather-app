import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';
import '../models/weather_model.dart';
import '../models/location_model.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_detail.dart';
import '../widgets/forecast_widget.dart';
import '../widgets/location_dialog.dart';
import '../widgets/add_location_dialog.dart';
import '../utils/background_helper.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();
  final TextEditingController _searchController = TextEditingController();
  
  WeatherData? _weatherData;
  List<ForecastData> _forecastData = [];
  List<SavedLocation> _savedLocations = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentCity = '';

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
    _getCurrentLocationWeather();
  }

  // REMOVE THE DUPLICATE METHOD - Keep only this one
  Future<void> _loadSavedLocations() async {
    final locations = await _storageService.getSavedLocations();
    setState(() => _savedLocations = locations);
    _debugSavedLocations(); // Add debug output
  }

  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.getWeatherByLocation();
      final forecast = await _weatherService.getForecastByLocation();
      
      print('Forecast data received: ${forecast.length} days');
      
      setState(() {
        _weatherData = weather;
        _forecastData = forecast;
        _currentCity = weather.cityName;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherForCoordinates(double lat, double lon) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.getWeatherByCoordinates(lat, lon);
      final forecast = await _weatherService.getForecastByCoordinates(lat, lon);
      
      print('Forecast data received: ${forecast.length} days');
      
      setState(() {
        _weatherData = weather;
        _forecastData = forecast;
        _currentCity = weather.cityName;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _addNewLocation(String city) async {
    try {
      // Get actual coordinates for the city
      final coordinates = await _weatherService.getCityCoordinates(city);
      
      final location = SavedLocation(
        cityName: coordinates['cityName'] ?? city,
        country: coordinates['country'] ?? '',
        lat: (coordinates['lat'] ?? 0).toDouble(),
        lon: (coordinates['lon'] ?? 0).toDouble(),
      );
      
      await _storageService.saveLocation(location);
      await _loadSavedLocations();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${location.cityName} added to saved locations'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add location: $city. Please check the city name.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      print('Error adding location: $e');
    }
  }

  Future<void> _removeLocation(SavedLocation location) async {
    try {
      await _storageService.removeLocation(location.cityName);
      await _loadSavedLocations();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${location.cityName} removed from saved locations'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove location: ${location.cityName}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      print('Error removing location: $e');
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => LocationDialog(
        locations: _savedLocations,
        onLocationSelected: (location) {
          _loadWeatherForCoordinates(location.lat, location.lon);
        },
        onLocationDeleted: _removeLocation,
        onAddNewLocation: _showAddLocationDialog,
      ),
    );
  }

  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AddLocationDialog(
        onCityAdded: _addNewLocation,
      ),
    );
  }

  Future<void> _searchWeather(String city) async {
    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weather = await _weatherService.getWeatherByCity(city);
      final forecast = await _weatherService.getForecastByCity(city);
      
      print('Forecast data received: ${forecast.length} days');
      
      setState(() {
        _weatherData = weather;
        _forecastData = forecast;
        _currentCity = city;
        _isLoading = false;
        _searchController.clear();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  // Add debug method to check saved locations
  void _debugSavedLocations() {
    print('=== SAVED LOCATIONS DEBUG ===');
    print('Total locations: ${_savedLocations.length}');
    for (var location in _savedLocations) {
      print(' - ${location.cityName}, ${location.country} (${location.lat}, ${location.lon})');
    }
    print('=============================');
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _weatherData != null
        ? BackgroundHelper.getWeatherGradient(_weatherData!.mainCondition)
        : BackgroundHelper.getWeatherGradient('default');

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentCity.isNotEmpty ? _currentCity : 'Weather App'),
        backgroundColor: const Color.fromARGB(199, 1, 57, 131),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_city),
            onPressed: _showLocationDialog,
            tooltip: 'Saved Locations',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocationWeather,
            tooltip: 'Current Location',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            ),
            SizedBox(height: 20),
            Text(
              'Fetching weather data...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _getCurrentLocationWeather,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                ),
                child: const Text('Try Again'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = '';
                  });
                },
                child: const Text(
                  'Dismiss',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBarWithAddButton(),
          const SizedBox(height: 20),
          if (_weatherData != null) ...[
            WeatherCard(weatherData: _weatherData!),
            const SizedBox(height: 20),
            WeatherDetails(weatherData: _weatherData!),
            const SizedBox(height: 20),
            if (_forecastData.isNotEmpty) 
              ForecastWidget(forecastData: _forecastData),
            if (_forecastData.isEmpty && _weatherData != null)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'No forecast data available',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Try searching for a different city',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          ] else ...[
            const Center(
              child: Text(
                'No weather data available',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBarWithAddButton() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search city...',
              hintStyle: const TextStyle(color: Colors.white70),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => _searchWeather(_searchController.text),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: const TextStyle(color: Colors.white),
            onSubmitted: _searchWeather,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddLocationDialog,
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
            ),
            tooltip: 'Add Location',
          ),
        ),
      ],
    );
  }
}