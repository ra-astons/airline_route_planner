import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import './string_format.dart';
import '../models/airport.dart';
import '../models/job_leg.dart';
import '../models/route_plan.dart';

class JobLegMarkers {
  final JobLeg _jobLeg;
  late LatLng _departurePoint;
  late LatLng _destinationPoint;
  late LatLng _middlePoint;
  final _dotted;

  JobLegMarkers(this._jobLeg, [this._dotted = false]) {
    _departurePoint = LatLng(_jobLeg.departureAirport.latitude, _jobLeg.departureAirport.longitude);
    _destinationPoint = LatLng(_jobLeg.destinationAirport.latitude, _jobLeg.destinationAirport.longitude);
    final path = Path.from([_departurePoint, _destinationPoint]);
    _middlePoint = path.center;
  }

  Marker get departureMarker {
    return _buildAirportMarker(_departurePoint, Colors.red, _jobLeg.departureAirport.icao);
  }

  Marker get destinationMarker {
    return _buildAirportMarker(_destinationPoint, Colors.green, _jobLeg.destinationAirport.icao);
  }

  Marker get middleMarker {
    var icon = Icon(Icons.archive, size: 20, color: Colors.white);
    var tooltipText = poundsFormat(_jobLeg.weight);
    if (_jobLeg.passengers > 0) {
      icon = Icon(Icons.group, size: 20, color: Colors.white);
      tooltipText = '${_jobLeg.passengers} ${_jobLeg.seatCategoryString}';
    }
    return Marker(
      point: _middlePoint,
      height: 30,
      width: 30,
      anchorPos: AnchorPos.align(AnchorAlign.center),
      builder: (ctx) => Container(
        child: Tooltip(
          message: tooltipText,
          textStyle: TextStyle(color: Colors.white),
          preferBelow: false,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.red),
          child: CircleAvatar(
            child: icon,
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }

  Polyline get pathLine {
    final path = Path.from([_departurePoint, _middlePoint, _destinationPoint]).equalize(10000, smoothPath: true);
    return Polyline(
      strokeWidth: 3,
      isDotted: _dotted,
      colorsStop: [0.0, 1.0],
      gradientColors: [
        Colors.red,
        Colors.green,
      ],
      points: path.coordinates,
    );
  }

  Marker _buildAirportMarker(LatLng point, Color color, String text) {
    return Marker(
      height: 40,
      width: 40,
      point: point,
      anchorPos: AnchorPos.align(AnchorAlign.top),
      builder: (ctx) => Container(
        child: Tooltip(
          message: text,
          textStyle: TextStyle(color: Colors.white),
          preferBelow: false,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
          child: Icon(Icons.location_pin, size: 40, color: color),
        ),
      ),
    );
  }
}

class RouteMarkers {
  final RoutePlan _routePlan;

  RouteMarkers(this._routePlan);

  List<Marker> getAirportMarkers() {
    return _routePlan.legs.map((l) => _buildAirportMarker(l.airport)).toList();
  }

  List<Polyline> getPathLines() {
    final List<Polyline> polylines = [];
    if (_routePlan.legs.length > 1) {
      for (var i = 0; i < _routePlan.legs.length - 1; i++) {
        final start = LatLng(_routePlan.legs[i].airport.latitude, _routePlan.legs[i].airport.longitude);
        final end = LatLng(_routePlan.legs[i + 1].airport.latitude, _routePlan.legs[i + 1].airport.longitude);
        var path = Path.from([start, end]);
        final middle = path.center;
        path = Path.from([start, middle, end]).equalize(10000, smoothPath: true);
        polylines.add(Polyline(
          strokeWidth: 3,
          colorsStop: [0.0, 1.0],
          gradientColors: [
            Colors.purple,
            Colors.blue,
          ],
          points: path.coordinates,
        ));
      }
    }
    return polylines;
  }

  Marker _buildAirportMarker(Airport airport) {
    final point = LatLng(airport.latitude, airport.longitude);
    return Marker(
      height: 20,
      width: 20,
      point: point,
      anchorPos: AnchorPos.align(AnchorAlign.top),
      builder: (ctx) => Container(
        child: Tooltip(
          message: airport.icao,
          textStyle: TextStyle(color: Colors.white),
          preferBelow: false,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
          child: Icon(Icons.location_pin, size: 20, color: Colors.blue),
        ),
      ),
    );
  }
}
