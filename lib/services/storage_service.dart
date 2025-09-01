import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class StorageService {
  static const String _locationsKey = 'saved_locations';

  Future<void> saveLocation(SavedLocation location) async {
    final prefs = await SharedPreferences.getInstance();
    final locations = await getSavedLocations();
    
    // Check if location already exists
    if (!locations.any((loc) => loc.cityName == location.cityName)) {
      locations.add(location);
      final jsonList = locations.map((loc) => loc.toJson()).toList();
      await prefs.setStringList(_locationsKey, jsonList.map((json) => jsonEncode(json)).toList());
    }
  }

  Future<List<SavedLocation>> getSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStringList = prefs.getStringList(_locationsKey) ?? [];
    
    final locations = <SavedLocation>[];
    for (final jsonString in jsonStringList) {
      try {
        final json = jsonDecode(jsonString);
        locations.add(SavedLocation.fromJson(json));
      } catch (e) {
        print('Error parsing location: $e');
      }
    }
    
    return locations;
  }

  Future<void> removeLocation(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final locations = await getSavedLocations();
    locations.removeWhere((loc) => loc.cityName == cityName);
    
    final jsonList = locations.map((loc) => loc.toJson()).toList();
    await prefs.setStringList(_locationsKey, jsonList.map((json) => jsonEncode(json)).toList());
  }

  Future<void> clearAllLocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationsKey);
  }
}