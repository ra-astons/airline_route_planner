import './fuel.dart';
import '../helpers/constants.dart';

class Aircraft {
  final String id;
  final String registration;
  final String name;
  final int emptyWeight;
  final int maxGrossWeight;
  final int maxPayloadWeight;
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
      emptyWeight: json['AircraftType']['emptyWeight'],
      maxGrossWeight: json['AircraftType']['maximumGrossWeight'],
      maxPayloadWeight: json['AircraftType']['maximumCargoWeight'],
      fuel: FUELS.firstWhere((f) => f.id == json['AircraftType']['fuelType']),
      fuelCapacity: json['AircraftType']['FuelTotalCapacityInGallons'],
      maxSeats: json['AircraftType']['seats'],
    );
  }
}
