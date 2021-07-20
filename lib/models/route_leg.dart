import './job_leg.dart';

class RouteLeg {
  String airportIcao;
  List<JobLeg> jobLegs;
  int fuelPercentage;

  RouteLeg(this.airportIcao, this.jobLegs, this.fuelPercentage);
}
