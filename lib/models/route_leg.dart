import './job_leg.dart';

class RouteLeg {
  String airportIcao;
  List<JobLeg> loadedJobLegs;
  List<JobLeg> unloadedJobLegs = [];
  int fuelPercentage;

  RouteLeg(this.airportIcao, this.loadedJobLegs, this.fuelPercentage);
}
