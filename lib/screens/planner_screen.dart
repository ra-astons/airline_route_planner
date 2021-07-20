import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../connectors/onair_api.dart';
import '../models/fleet.dart';
import '../models/pending_jobs.dart';
import '../models/settings.dart';
import '../widgets/app_drawer.dart';

class PlannerScreen extends StatefulWidget {
  static const routeName = '/planner';
  final String title;

  PlannerScreen(this.title);

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late Fleet _fleet;
  late PendingJobs _pendingJobs;
  var _isInit = true;

  void _fetchData() async {
    final _settings = Provider.of<Settings>(context);
    final onAir = OnAirApi(_settings.oaApiKey, _settings.companyId);
    _fleet.updateAircrafts(await onAir.fetchFleet());
    _pendingJobs.updateJobs(await onAir.fetchPendingJobs());
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fetchData();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: AppDrawer(widget.title),
      body: Center(
        child: Text('PLANNER'),
      ),
    );
  }
}
