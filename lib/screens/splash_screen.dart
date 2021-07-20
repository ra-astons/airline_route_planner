import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './planner_screen.dart';
import './settings_screen.dart';
import '../connectors/onair_api.dart';
import '../models/fleet.dart';
import '../models/pending_jobs.dart';
import '../models/settings.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Fleet _fleet;
  late PendingJobs _pendingJobs;
  late Settings _settings;

  @override
  void initState() {
    _fleet = Provider.of<Fleet>(context, listen: false);
    _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
    _settings = Provider.of<Settings>(context, listen: false);
    loadSettingsAndData();
    super.initState();
  }

  void loadSettingsAndData() async {
    _settings.loadSettings();
    while (!_settings.isLoaded) {
      await Future.delayed(Duration(milliseconds: 1));
    }
    final navigator = Navigator.of(context);
    if (_settings.oaApiKey.isEmpty || _settings.companyId.isEmpty) {
      navigator.pushReplacementNamed(SettingsScreen.routeName);
    } else {
      final onAir = OnAirApi(_settings.oaApiKey, _settings.companyId);
      _fleet.updateAircrafts(await onAir.fetchFleet());
      _pendingJobs.updateJobs(await onAir.fetchPendingJobs());

      navigator.pushReplacementNamed(PlannerScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueGrey.shade900],
            transform: GradientRotation(90),
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
