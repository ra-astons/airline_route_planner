import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/fleet.dart';

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
            _fleet.setActive(value!);
          },
        ),
      ],
    );
  }
}
