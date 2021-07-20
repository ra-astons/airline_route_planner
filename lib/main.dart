import 'package:flutter/material.dart';

void main() {
  runApp(AirlineRoutePlanner());
}

class AirlineRoutePlanner extends StatelessWidget {
  final title = 'Airline Route Planner';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Text(title.toUpperCase()),
          )),
    );
  }
}
