import 'package:flutter/foundation.dart';

import './job_leg.dart';
import './route_leg.dart';

class RoutePlan with ChangeNotifier {
  List<RouteLeg> _legs = [];
  var _currentCargo = 0.0;
  var _currentPax = 0;

  List<RouteLeg> get legs => [..._legs];

  double get currentCargo => _currentCargo;
  int get currentPax => _currentPax;

  List<JobLeg> addRouteLeg(RouteLeg newRouteLeg) {
    // Load
    _currentCargo += newRouteLeg.loadedJobLegs.fold(0.0, (sum, l) => sum + l.weight);
    _currentPax += newRouteLeg.loadedJobLegs.fold(0, (sum, l) => sum + l.passengers);

    // Unload
    final List<JobLeg> jobLegsToUnload = [];
    _legs.forEach((routeLeg) {
      jobLegsToUnload.addAll(routeLeg.loadedJobLegs.where((l) => l.destinationAirport == newRouteLeg.airport));
    });
    newRouteLeg.unloadedJobLegs = jobLegsToUnload;
    _currentCargo += jobLegsToUnload.fold(0.0, (sum, l) => sum - l.weight);
    _currentPax += jobLegsToUnload.fold(0, (sum, l) => sum - l.passengers);

    _legs.add(newRouteLeg);
    notifyListeners();
    return jobLegsToUnload;
  }
}
