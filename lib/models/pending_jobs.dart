import 'package:flutter/foundation.dart';

import './job.dart';

class PendingJobs with ChangeNotifier {
  List<Job> _jobs = [];

  List<Job> get jobs => [..._jobs];

  void updateJobs(List<Job> jobs) {
    _jobs = jobs;
    notifyListeners();
  }
}
