import 'package:flutter/material.dart';

class PlannerBlock extends StatelessWidget {
  final Widget child;

  PlannerBlock({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        child: this.child,
      ),
    );
  }
}
