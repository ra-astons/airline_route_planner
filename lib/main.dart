import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/settings.dart';
import './screens/planner_screen.dart';
import './screens/settings_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(AirlineRoutePlanner());
}

class AirlineRoutePlanner extends StatelessWidget {
  final title = 'Airline Route Planner';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Settings()),
      ],
      child: MaterialApp(
        title: title,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          accentColor: Colors.blueAccent,
        ),
        routes: {
          SplashScreen.routeName: (_) => SplashScreen(),
          SettingsScreen.routeName: (_) => SettingsScreen(),
          PlannerScreen.routeName: (_) => PlannerScreen(title),
        },
      ),
    );
  }
}
