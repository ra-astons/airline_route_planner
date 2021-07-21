import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import '../helpers/map_marker.dart';
import '../models/route_plan.dart';
import '../models/pending_jobs.dart';

class PlannerMap extends StatefulWidget {
  @override
  _PlannerMapState createState() => _PlannerMapState();
}

class _PlannerMapState extends State<PlannerMap> {
  final _mapController = MapController();
  final _fitBoundOptions = FitBoundsOptions(padding: EdgeInsets.all(50));
  late PendingJobs _pendingJobs;
  late RoutePlan _routePlan;

  List<Marker> _markers = [];
  List<Polyline> _polylines = [];

  LatLngBounds _buildBounds() {
    final allLatLngs = _markers.map((e) => e.point).toList();
    return LatLngBounds.fromPoints(allLatLngs);
  }

  void _buildSelectedLegsMarkers() {
    _markers = [];
    _polylines = [];

    // Selected legs
    final selectedLegs = _pendingJobs.jobs.map((e) => e.selectedLegs).expand((e) => e).toList();
    final selectedLegMarkers = selectedLegs.map((l) => JobLegMarkers(l, true));
    selectedLegMarkers.forEach((legMarker) {
      _markers.add(legMarker.departureMarker);
      _markers.add(legMarker.destinationMarker);
      _markers.add(legMarker.middleMarker);
      _polylines.add(legMarker.pathLine);
    });

    // Loaded legs
    final loadedLegs = _pendingJobs.jobs.map((e) => e.loadedLegs).expand((e) => e).toList();
    final loadedLegMarkers = loadedLegs.map((l) => JobLegMarkers(l));
    loadedLegMarkers.forEach((legMarker) {
      _markers.add(legMarker.departureMarker);
      _markers.add(legMarker.destinationMarker);
      _markers.add(legMarker.middleMarker);
      _polylines.add(legMarker.pathLine);
    });

    // Route
    RouteMarkers routeMarkers = RouteMarkers(_routePlan);
    _markers.addAll(routeMarkers.getAirportMarkers());
    _polylines.addAll(routeMarkers.getPathLines());

    if (_markers.isNotEmpty) {
      _mapController.fitBounds(_buildBounds(), options: _fitBoundOptions);
    }
    setState(() {});
  }

  @override
  void initState() {
    _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
    _pendingJobs.addListener(_buildSelectedLegsMarkers);
    _routePlan = Provider.of<RoutePlan>(context, listen: false);
    _routePlan.addListener(_buildSelectedLegsMarkers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              bounds: LatLngBounds.fromPoints([LatLng(90.0, -180.0), LatLng(-90.0, 180.0)]),
              center: LatLng(0, 0),
              zoom: 1.0,
            ),
            children: [
              TileLayerWidget(
                options: TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
              ),
              PolylineLayerWidget(
                options: PolylineLayerOptions(
                  polylines: _polylines,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _markers,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _mapController.move(_mapController.center, _mapController.zoom + 1);
                  });
                },
                icon: Icon(Icons.zoom_in),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _mapController.move(_mapController.center, _mapController.zoom - 1);
                  });
                },
                icon: Icon(Icons.zoom_out),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  _mapController.fitBounds(_buildBounds());
                },
                icon: Icon(
                  Icons.zoom_out_map,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
