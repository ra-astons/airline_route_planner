import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/job_leg.dart';
import '../models/airport.dart';

enum MarkerTypes {
  departure,
  destination,
}

Marker buildMarker(Airport airport, MarkerTypes markerType) {
  var color = Colors.green;
  if (markerType == MarkerTypes.destination) color = Colors.red;
  return Marker(
    height: 62,
    width: 62,
    point: LatLng(airport.latitude, airport.longitude),
    anchorPos: AnchorPos.align(AnchorAlign.top),
    builder: (ctx) => Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(airport.icao, style: TextStyle(color: color)),
          Icon(Icons.location_pin, color: color),
        ],
      ),
    ),
  );
}

Polyline buildPolyline(JobLeg leg) {
  return Polyline(
    strokeWidth: 4,
    colorsStop: [0.0, 1.0],
    gradientColors: [
      Colors.green,
      Colors.red,
    ],
    isDotted: true,
    points: [
      LatLng(
        leg.departureAirport.latitude,
        leg.departureAirport.longitude,
      ),
      LatLng(
        leg.destinationAirport.latitude,
        leg.destinationAirport.longitude,
      )
    ],
  );
}
