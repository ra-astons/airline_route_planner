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
  var _isInit = true;
  List<Polyline> _polylines = [];
  List<Marker> _departureMarkers = [];
  List<Marker> _destinationMarkers = [];
  List<Marker> _allMarkers = [];
  List<Marker> _middleMarkers = [];

  LatLngBounds _buildBounds() {
    final allLatLngs = _allMarkers.map((e) => e.point).toList();
    return LatLngBounds.fromPoints(allLatLngs);
  }

  void _buildMarkers() {
    final legs = _pendingJobs.jobs.map((e) => e.selectedLegs).expand((e) => e).toList();
    _departureMarkers = _destinationMarkers = _middleMarkers = [];
    _polylines = [];
    final legMarkers = legs.map((l) => JobLegMarkers(l));
    legMarkers.forEach((legMarker) {
      _departureMarkers.add(legMarker.departureMarker);
      _destinationMarkers.add(legMarker.destinationMarker);
      _middleMarkers.add(legMarker.middleMarker);
      _polylines.add(legMarker.pathLine);
    });
    _allMarkers = [..._departureMarkers, ..._destinationMarkers];
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _pendingJobs = Provider.of<PendingJobs>(context);
      _isInit = false;
      _pendingJobs.addListener(() {
        setState(() {
          _buildMarkers();
          if (_allMarkers.isNotEmpty) {
            _mapController.fitBounds(_buildBounds(), options: _fitBoundOptions);
          }
        });
      });
    }
    super.didChangeDependencies();
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
                  markers: _middleMarkers,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _destinationMarkers,
                ),
              ),
              MarkerLayerWidget(
                options: MarkerLayerOptions(
                  markers: _departureMarkers,
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
