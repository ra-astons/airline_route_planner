import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/route_plan.dart';

class RouteLegsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routePlan = Provider.of<RoutePlan>(context);
    return ListView.builder(
      itemCount: routePlan.legs.length,
      itemBuilder: (_, index) {
        var totalCargo = 0.0;
        totalCargo = routePlan.legs[index].jobLegs.fold(0.0, (sum, l) => sum + l.weight);
        var totalPax = 0;
        totalPax = routePlan.legs[index].jobLegs.fold(0, (sum, l) => sum + l.passengers);
        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  routePlan.legs[index].airportIcao,
                  textAlign: TextAlign.center,
                ),
              ),
              VerticalDivider(),
              SizedBox(
                width: 40,
                child: Text(
                  routePlan.legs[index].jobLegs.length.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              VerticalDivider(),
              SizedBox(
                width: 40,
                child: Text(
                  totalCargo.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              VerticalDivider(),
              SizedBox(
                width: 40,
                child: Text(
                  totalPax.toString(),
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
