import 'package:flutter/foundation.dart';

import './job.dart';

class PendingJobs with ChangeNotifier {
  List<Job> _jobs = [];
  String _departureFilter = '';
  var _showSightSeeing = false;
  var _showCompleted = false;

  List<Job> get jobs {
    List<Job> jobs = [..._jobs];
    if (!_showSightSeeing) {
      jobs = jobs.where((j) => !j.hasSightSeeingLeg).toList();
    }
    if (_departureFilter.isNotEmpty) {
      jobs = jobs.where((j) => j.legs.any((l) => l.departureAirport.icao.contains(_departureFilter))).toList();
    }
    return jobs;
  }

  bool get completedShown => _showCompleted;
  bool get sightSeeingShown => _showSightSeeing;

  void filterByDeparture(String icao) {
    _departureFilter = icao;
    _jobs.forEach((j) => j.filterByDeparture(icao));
    notifyListeners();
  }

  void showSightSeeing(bool showSightSeeing) {
    _showSightSeeing = showSightSeeing;
    notifyListeners();
  }

  void showCompleted(bool showCompleted) {
    _showCompleted = showCompleted;
    _jobs.forEach((j) => j.showCompleted(showCompleted));
    notifyListeners();
  }

  void toggleSelectLeg(String legId, bool selected) {
    _jobs
        .firstWhere((j) => j.legs.any((l) => l.id == legId))
        .legs
        .firstWhere((l) => l.id == legId)
        .toggleSelect(selected);
    notifyListeners();
  }

  void updateJobs(List<Job> jobs) {
    _jobs = jobs;
    notifyListeners();
  }
}
