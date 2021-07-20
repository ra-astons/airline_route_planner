import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './planner_screen.dart';
import './settings_screen.dart';
import '../models/settings.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  void loadSettings() async {
    final settings = Provider.of<Settings>(context, listen: false);
    settings.loadSettings();
    //TODO: remove fake loading time
    await Future.delayed(Duration(seconds: 1));
    while (!settings.isLoaded) {
      await Future.delayed(Duration(milliseconds: 1));
    }
    final navigator = Navigator.of(context);
    if (settings.oaApiKey.isEmpty || settings.companyId.isEmpty) {
      navigator.pushReplacementNamed(SettingsScreen.routeName);
    } else {
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
