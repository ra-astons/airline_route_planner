import 'package:flutter/foundation.dart';

import './route_leg.dart';

class RoutePlan with ChangeNotifier {
  List<RouteLeg> _legs = [];

  List<RouteLeg> get legs => [..._legs];

  void addRouteLeg(RouteLeg routeLeg) {
    _legs.add(routeLeg);
    notifyListeners();
  }
}
