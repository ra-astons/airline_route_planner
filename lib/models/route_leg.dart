import './airport.dart';
import './job_leg.dart';

class RouteLeg {
  Airport airport;
  List<JobLeg> loadedJobLegs;
  List<JobLeg> unloadedJobLegs = [];
  int fuelPercentage;

  RouteLeg(this.airport, this.loadedJobLegs, this.fuelPercentage);
}
