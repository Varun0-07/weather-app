class SavedLocation {
  final String cityName;
  final String country;
  final double lat;
  final double lon;

  SavedLocation({
    required this.cityName,
    required this.country,
    required this.lat,
    required this.lon,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'country': country,
      'lat': lat,
      'lon': lon,
    };
  }

  factory SavedLocation.fromJson(Map<String, dynamic> json) {
    return SavedLocation(
      cityName: json['cityName'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedLocation &&
          runtimeType == other.runtimeType &&
          cityName == other.cityName;

  @override
  int get hashCode => cityName.hashCode;

  @override
  String toString() {
    return 'SavedLocation{cityName: $cityName, country: $country, lat: $lat, lon: $lon}';
  }
}