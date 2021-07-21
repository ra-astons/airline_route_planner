import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/string_format.dart';
import '../models/route_plan.dart';

class RouteLegsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routePlan = Provider.of<RoutePlan>(context);
    return ListView.builder(
      itemCount: routePlan.legs.length,
      itemBuilder: (_, index) {
        var loadedCargo = 0.0;
        loadedCargo = routePlan.legs[index].loadedJobLegs.fold(0.0, (sum, l) => sum + l.weight);
        var loadedPax = 0;
        loadedPax = routePlan.legs[index].loadedJobLegs.fold(0, (sum, l) => sum + l.passengers);
        var unloadedCargo = 0.0;
        unloadedCargo = routePlan.legs[index].unloadedJobLegs.fold(0.0, (sum, l) => sum + l.weight);
        var unloadedPax = 0;
        unloadedPax = routePlan.legs[index].unloadedJobLegs.fold(0, (sum, l) => sum + l.passengers);
        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              VerticalDivider(),
              SizedBox(
                width: 40,
                child: Text(
                  routePlan.legs[index].airport.icao,
                  textAlign: TextAlign.center,
                ),
              ),
              VerticalDivider(),
              SizedBox(
                width: 100,
                child: Text(
                  poundsFormat(loadedCargo),
                  textAlign: TextAlign.end,
                ),
              ),
              VerticalDivider(),
              SizedBox(
                width: 40,
                child: Text(
                  loadedPax.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              VerticalDivider(),
              SizedBox(
                width: 100,
                child: Text(
                  poundsFormat(unloadedCargo),
                  textAlign: TextAlign.end,
                ),
              ),
              VerticalDivider(),
              SizedBox(
                width: 40,
                child: Text(
                  unloadedPax.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              VerticalDivider(),
              SizedBox(
                width: 40,
                child: Text(
                  routePlan.legs[index].fuelPercentage.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
