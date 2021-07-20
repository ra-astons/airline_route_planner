import 'package:flutter/material.dart';

import '../widgets/aircraft_selector.dart';
import '../widgets/app_drawer.dart';
import '../widgets/pending_jobs_list.dart';

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
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PendingJobsList(),
                ),
                Expanded(
                  flex: 2,
                  child: Text('MAP'),
                ),
              ],
            ),
          ),
          Text('NEW LEG FORM'),
          Expanded(flex: 2, child: Text('ROUTE PLANNER')),
        ],
      ),
    );
  }
}
