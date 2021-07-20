import 'package:flutter/material.dart';

import '../widgets/aircraft_selector.dart';
import '../widgets/app_drawer.dart';

class PlannerScreen extends StatefulWidget {
  static const routeName = '/planner';
  final String title;

  PlannerScreen(this.title);

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
            Expanded(
              child: AircraftSelector(),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(widget.title),
      body: Center(
        child: Text('PLANNER'),
      ),
    );
  }
}
