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
  late PendingJobs _pendingJobs;
  var _isInit = true;
  LatLngBounds _bounds = LatLngBounds.fromPoints([LatLng(90.0, -180.0), LatLng(-90.0, 180.0)]);
  List<Polyline> _polylines = [];
  List<Marker> _departureMarkers = [];
  List<Marker> _destinationMarkers = [];

  LatLngBounds _buildBounds() {
    if (_departureMarkers.isEmpty && _destinationMarkers.isEmpty) {
      return LatLngBounds.fromPoints([LatLng(90.0, -180.0), LatLng(-90.0, 180.0)]);
    } else {
      final markers = [
        ..._departureMarkers,
        ..._destinationMarkers,
      ];
      markers.sort((a, b) => b.point.latitude.compareTo(a.point.latitude));
      final maxLatitude = markers.first.point.latitude + 0.5;
      final minLatitude = markers.last.point.latitude - 0.5;
      markers.sort((a, b) => b.point.longitude.compareTo(a.point.longitude));
      final maxLongitude = markers.first.point.longitude + 0.5;
      final minLongitude = markers.last.point.longitude - 0.5;
      return LatLngBounds.fromPoints([LatLng(minLatitude, minLongitude), LatLng(maxLatitude, maxLongitude)]);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _pendingJobs = Provider.of<PendingJobs>(context);
      _isInit = false;
      _pendingJobs.addListener(() {
        setState(() {
          _departureMarkers = _getDepartureMarkers();
          _destinationMarkers = _getDestinationMarkers();
          _polylines = _getPolylines();
          _mapController.fitBounds(_buildBounds());
        });
      });
    }
    super.didChangeDependencies();
  }

  List<Marker> _getDepartureMarkers() {
    final legs = _pendingJobs.jobs.map((e) => e.selectedLegs).expand((e) => e).toList();
    _departureMarkers = legs.map((l) => buildMarker(l.departureAirport, MarkerTypes.departure)).toList();
    return _departureMarkers;
  }

  List<Marker> _getDestinationMarkers() {
    final legs = _pendingJobs.jobs.map((e) => e.selectedLegs).expand((e) => e).toList();
    _destinationMarkers = legs.map((l) => buildMarker(l.destinationAirport, MarkerTypes.destination)).toList();
    return _destinationMarkers;
  }

  List<Polyline> _getPolylines() {
    final legs = _pendingJobs.jobs.map((e) => e.selectedLegs).expand((e) => e).toList();
    return legs.map((l) => buildPolyline(l)).toList();
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
              bounds: _bounds,
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
