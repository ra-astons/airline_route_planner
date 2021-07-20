import './job.dart';

class PendingJobs {
  List<Job> _jobs = [];

  List<Job> get jobs => [..._jobs];

  void updateJobs(List<Job> jobs) {
    _jobs = jobs;
  }
}
