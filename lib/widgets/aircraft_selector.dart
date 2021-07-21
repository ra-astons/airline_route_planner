import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/fleet.dart';
import '../models/pending_jobs.dart';
import '../models/route_plan.dart';

class AircraftSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _fleet = Provider.of<Fleet>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(Icons.flight),
        ),
        DropdownButton<String>(
          value: _fleet.activeAircraft.id,
          items: _fleet.aircrafts.map((aircraft) {
            return DropdownMenuItem(
              value: aircraft.id,
              child: Text(aircraft.toString()),
            );
          }).toList(),
          onChanged: (value) {
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  content: Text('This will reset your route plan.\nDo you want to proceed?'),
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
                        _fleet.setActive(value!);
                        final _pendingJobs = Provider.of<PendingJobs>(ctx, listen: false);
                        final _routePlan = Provider.of<RoutePlan>(ctx, listen: false);
                        _pendingJobs.reset();
                        _routePlan.reset();
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
