import 'package:flutter/foundation.dart';

import './job.dart';

class PendingJobs with ChangeNotifier {
  List<Job> _jobs = [];
  String _departureFilter = '';
  var _hideSightSeeing = false;

  List<Job> get jobs {
    List<Job> jobs = [..._jobs];
    if (_hideSightSeeing) {
      jobs = jobs.where((j) => !j.hasSightSeeingLeg).toList();
    }
    if (_departureFilter.isNotEmpty) {
      jobs = jobs.where((j) => j.legs.any((l) => l.departureAirport.icao.contains(_departureFilter))).toList();
    }
    return jobs;
  }

  void filterByDeparture(String icao) {
    _departureFilter = icao;
    _jobs.forEach((j) => j.filterByDeparture(icao));
    notifyListeners();
  }

  void hideSightSeeing(bool hideSightSeeing) {
    _hideSightSeeing = hideSightSeeing;
    notifyListeners();
  }

  void updateJobs(List<Job> jobs) {
    _jobs = jobs;
    notifyListeners();
  }
}
