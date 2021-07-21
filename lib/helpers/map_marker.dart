import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/job_leg.dart';

class JobLegMarkers {
  final JobLeg _jobLeg;
  late LatLng _departurePoint;
  late LatLng _destinationPoint;
  late LatLng _middlePoint;

  JobLegMarkers(this._jobLeg) {
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
    var tooltipText = _jobLeg.weight.toString();
    if (_jobLeg.passengers > 0) {
      icon = Icon(Icons.group, size: 20, color: Colors.white);
      tooltipText = _jobLeg.passengers.toString();
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
