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
              tooltip: 'Delete route plan',
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: _resetRoute,
            ),
          ],
        ),
        IntrinsicHeight(
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    'Airport',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                VerticalDivider(),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Loaded cargo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                VerticalDivider(),
                SizedBox(
                  width: 130,
                  child: Text(
                    'Loaded passengers',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                VerticalDivider(),
                SizedBox(
                  width: 110,
                  child: Text(
                    'Unloaded cargo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                VerticalDivider(),
                SizedBox(
                  width: 140,
                  child: Text(
                    'Unloaded passengers',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                VerticalDivider(),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Loaded fuel',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 2),
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
              return Column(
                children: [
                  IntrinsicHeight(
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 70,
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
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          VerticalDivider(),
                          SizedBox(
                            width: 130,
                            child: Text(
                              loadedPax.toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          VerticalDivider(),
                          SizedBox(
                            width: 110,
                            child: Text(
                              poundsFormat(unloadedCargo),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          VerticalDivider(),
                          SizedBox(
                            width: 140,
                            child: Text(
                              unloadedPax.toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          VerticalDivider(),
                          SizedBox(
                            width: 80,
                            child: Text(
                              '${_routePlan.legs[index].fuelPercentage.toString()}%',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
