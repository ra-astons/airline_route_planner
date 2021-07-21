import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/string_format.dart';
import '../models/pending_jobs.dart';
import '../models/route_plan.dart';

class RouteLegsList extends StatefulWidget {
  @override
  _RouteLegsListState createState() => _RouteLegsListState();
}

class _RouteLegsListState extends State<RouteLegsList> {
  late RoutePlan _routePlan;
  var _isInit = true;

  void _resetRoute() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Text('This will reset all your route.\nDo you want to proceed?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.red)),
              onPressed: () {
                final pendingJobs = Provider.of<PendingJobs>(context, listen: false);
                pendingJobs.reset();
                _routePlan.reset();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _routePlan = Provider.of<RoutePlan>(context);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetRoute,
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _routePlan.legs.length,
            itemBuilder: (_, index) {
              var loadedCargo = 0.0;
              loadedCargo = _routePlan.legs[index].loadedJobLegs.fold(0.0, (sum, l) => sum + l.weight);
              var loadedPax = 0;
              loadedPax = _routePlan.legs[index].loadedJobLegs.fold(0, (sum, l) => sum + l.passengers);
              var unloadedCargo = 0.0;
              unloadedCargo = _routePlan.legs[index].unloadedJobLegs.fold(0.0, (sum, l) => sum + l.weight);
              var unloadedPax = 0;
              unloadedPax = _routePlan.legs[index].unloadedJobLegs.fold(0, (sum, l) => sum + l.passengers);
              return IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VerticalDivider(),
                    SizedBox(
                      width: 40,
                      child: Text(
                        _routePlan.legs[index].airport.icao,
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
                        _routePlan.legs[index].fuelPercentage.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
