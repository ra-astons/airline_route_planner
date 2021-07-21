import './fuel.dart';
import '../helpers/constants.dart';

class Aircraft {
  final String id;
  final String registration;
  final String name;
  final double emptyWeight;
  final double maxGrossWeight;
  final double maxPayloadWeight;
  final Fuel fuel;
  final double fuelCapacity;
  final int maxSeats;
  var isActive = false;

  Aircraft({
    required this.id,
    required this.registration,
    required this.name,
    required this.emptyWeight,
    required this.maxGrossWeight,
    required this.maxPayloadWeight,
    required this.fuel,
    required this.fuelCapacity,
    required this.maxSeats,
  });

  String toString() => '$registration - $name';

  double get maxFuelWeight => fuelCapacity * fuel.density;

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(
      id: json['Id'],
      registration: json['Identifier'],
      name: json['AircraftType']['DisplayName'],
      emptyWeight: json['AircraftType']['emptyWeight'].toDouble(),
      maxGrossWeight: json['AircraftType']['maximumGrossWeight'].toDouble(),
      maxPayloadWeight: json['AircraftType']['maximumCargoWeight'].toDouble(),
      fuel: FUELS.firstWhere((f) => f.id == json['AircraftType']['fuelType']),
      fuelCapacity: json['AircraftType']['FuelTotalCapacityInGallons'],
      maxSeats: json['AircraftType']['seats'],
    );
  }
}
