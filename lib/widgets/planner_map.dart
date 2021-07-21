import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import '../helpers/map_marker.dart';
import '../models/pending_jobs.dart';

class PlannerMap extends StatefulWidget {
  @override
  _PlannerMapState createState() => _PlannerMapState();
}

class _PlannerMapState extends State<PlannerMap> {
  final _mapController = MapController();
  final _fitBoundOptions = FitBoundsOptions(padding: EdgeInsets.all(50));
  late PendingJobs _pendingJobs;

  List<Marker> _selectedLegsDepartureMarkers = [];
  List<Marker> _selectedLegsDestinationMarkers = [];
  List<Polyline> _selectedLegsPolylines = [];
  List<Marker> _selectedLegsMiddleMarkers = [];

  List<Marker> _loadedLegsDepartureMarkers = [];
  List<Marker> _loadedLegsDestinationMarkers = [];
  List<Polyline> _loadedLegsPolylines = [];
  List<Marker> _loadedLegsMiddleMarkers = [];

  List<Marker> _allMarkers = [];

  LatLngBounds _buildBounds() {
    final allLatLngs = _allMarkers.map((e) => e.point).toList();
    return LatLngBounds.fromPoints(allLatLngs);
  }

  void _buildSelectedLegsMarkers() {
    // Selected legs
    final selectedLegs = _pendingJobs.jobs.map((e) => e.selectedLegs).expand((e) => e).toList();
    _selectedLegsDepartureMarkers = _selectedLegsDestinationMarkers = _selectedLegsMiddleMarkers = [];
    _selectedLegsPolylines = [];
    final selectedLegMarkers = selectedLegs.map((l) => JobLegMarkers(l, true));
    selectedLegMarkers.forEach((legMarker) {
      _selectedLegsDepartureMarkers.add(legMarker.departureMarker);
      _selectedLegsDestinationMarkers.add(legMarker.destinationMarker);
      _selectedLegsMiddleMarkers.add(legMarker.middleMarker);
      _selectedLegsPolylines.add(legMarker.pathLine);
    });

    // Loaded legs
    final loadedLegs = _pendingJobs.jobs.map((e) => e.loadedLegs).expand((e) => e).toList();
    _loadedLegsDepartureMarkers = _loadedLegsDestinationMarkers = _loadedLegsMiddleMarkers = [];
    _loadedLegsPolylines = [];
    final loadedLegMarkers = loadedLegs.map((l) => JobLegMarkers(l));
    loadedLegMarkers.forEach((legMarker) {
      _loadedLegsDepartureMarkers.add(legMarker.departureMarker);
      _loadedLegsDestinationMarkers.add(legMarker.destinationMarker);
      _loadedLegsMiddleMarkers.add(legMarker.middleMarker);
      _loadedLegsPolylines.add(legMarker.pathLine);
    });

    _allMarkers = [
      ..._selectedLegsDepartureMarkers,
      ..._selectedLegsDestinationMarkers,
      ..._loadedLegsDepartureMarkers,
      ..._loadedLegsDestinationMarkers,
    ];
    if (_allMarkers.isNotEmpty) {
      _mapController.fitBounds(_buildBounds(), options: _fitBoundOptions);
    }
    setState(() {});
  }

  @override
  void initState() {
    _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
    _pendingJobs.addListener(_buildSelectedLegsMarkers);
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
                  polylines: _selectedLegsPolylines,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _selectedLegsMiddleMarkers,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _selectedLegsDestinationMarkers,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _selectedLegsDepartureMarkers,
                ),
              ),
              PolylineLayerWidget(
                options: PolylineLayerOptions(
                  polylines: _loadedLegsPolylines,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _loadedLegsMiddleMarkers,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _loadedLegsDestinationMarkers,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _loadedLegsDepartureMarkers,
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
