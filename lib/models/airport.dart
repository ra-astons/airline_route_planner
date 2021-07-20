class Airport {
  final String id;
  final String icao;
  final String name;
  final double latitude;
  final double longitude;

  Airport({
    required this.id,
    required this.icao,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(other) => other is Airport && other.id == id;

  @override
  int get hashCode => id.hashCode;

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['Id'],
      icao: json['ICAO'],
      name: json['Name'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
    );
  }
}
