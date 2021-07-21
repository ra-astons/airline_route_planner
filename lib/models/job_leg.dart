import 'package:flutter/foundation.dart';

import './airport.dart';

enum JobLegTypes {
  cargo,
  charter,
}

enum SeatCategories {
  economy,
  buisiness,
  first,
}

class JobLeg with ChangeNotifier {
  final String id;
  final String description;
  final Airport departureAirport;
  final Airport destinationAirport;
  final Airport? currentAirport;
  JobLegTypes type;
  final double weight;
  final int passengers;
  SeatCategories seatCategory;
  final int charterType;
  var _isSelected = false;
  var _isLoaded = false;
  var _isUnloaded = false;

  JobLeg({
    required this.id,
    required this.description,
    required this.departureAirport,
    required this.destinationAirport,
    this.currentAirport,
    required this.type,
    this.weight = 0.0,
    this.passengers = 0,
    this.seatCategory = SeatCategories.economy,
    this.charterType = 0,
  });

  bool get isSelected => _isSelected;

  bool get isSightSeeing => charterType == 3;

  bool get isComplete => currentAirport != null && currentAirport == destinationAirport && !isSightSeeing;

  bool get isLoaded => _isLoaded;

  bool get isUnloaded => _isUnloaded;

  void toggleSelect(bool selected) {
    _isSelected = selected;
    notifyListeners();
  }

  void load() {
    _isLoaded = true;
    _isSelected = false;
    notifyListeners();
  }

  void unload() {
    _isLoaded = false;
    _isUnloaded = true;
    notifyListeners();
  }

  String get seatCategoryString {
    switch (seatCategory) {
      case SeatCategories.economy:
        return 'Eco';
      case SeatCategories.buisiness:
        return 'Bus';
      case SeatCategories.first:
        return 'Fir';
    }
  }

  factory JobLeg.fromJson(Map<String, dynamic> json) {
    final id = json["Id"] as String;
    var description = json['Description'] as String;
    final departureAirport = Airport.fromJson(json['DepartureAirport']);
    final destinationAirport = Airport.fromJson(json['DestinationAirport']);
    final currentAirport = json.containsKey('CurrentAirport') ? Airport.fromJson(json['CurrentAirport']) : null;

    if (json.containsKey('CargoType')) {
      return JobLeg(
        id: id,
        description: '${json['Description']} - (${json['CargoType']['Name']})',
        departureAirport: departureAirport,
        destinationAirport: destinationAirport,
        currentAirport: currentAirport,
        type: JobLegTypes.cargo,
        weight: json['Weight'] as double,
      );
    } else {
      return JobLeg(
        id: id,
        description: '$description - (${json['CharterType']['Name']})',
        departureAirport: departureAirport,
        destinationAirport: destinationAirport,
        currentAirport: currentAirport,
        type: JobLegTypes.charter,
        passengers: json["PassengersNumber"],
        seatCategory: SeatCategories.values[json['MinPAXSeatConf']],
        charterType: json['CharterType']['CharterTypeCategory'],
      );
    }
  }
}
