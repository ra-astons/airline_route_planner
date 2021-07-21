import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../connectors/onair_api.dart';
import '../helpers/constants.dart';
import '../helpers/string_format.dart';
import '../models/airport.dart';
import '../models/fleet.dart';
import '../models/job_leg.dart';
import '../models/pending_jobs.dart';
import '../models/route_leg.dart';
import '../models/route_plan.dart';
import '../models/settings.dart';

class NewRouteLeg extends StatefulWidget {
  @override
  _NewRouteLegState createState() => _NewRouteLegState();
}

class _NewRouteLegState extends State<NewRouteLeg> {
  late Settings _settings;
  late PendingJobs _pendingJobs;
  late Fleet _fleet;
  late RoutePlan _routePlan;

  final _formKey = GlobalKey<FormState>();
  final _okTextStyle = TextStyle(color: Colors.white);
  final _errorTextStyle = TextStyle(color: Colors.red);
  var _airportIcao = '';

  var _loadedFuelPerc = 100.0;
  var _totalWeight = 0.0;
  var _totalCargo = 0.0;
  var _totalPayload = 0.0;
  var _totalPax = 0;
  var _overWeight = false;
  var _overPayload = false;
  var _overPax = false;
  var _addDisabled = false;
  List<JobLeg> _loadedLegs = [];

  void _submit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final onAir = OnAirApi(_settings.oaApiKey, _settings.companyId);
      try {
        Airport airport = await onAir.fetchAirport(_airportIcao);
        final List<JobLeg> loadedJobLegs = [];
        _pendingJobs.jobs.forEach((j) {
          loadedJobLegs.addAll(j.selectedLegs);
        });
        _formKey.currentState!.reset();
        _pendingJobs.filterByDeparture('');
        _pendingJobs.resetSelection();
        final unloadedJobLegs = _routePlan.addRouteLeg(RouteLeg(airport, loadedJobLegs, _loadedFuelPerc.floor()));
        loadedJobLegs.forEach((l) => _pendingJobs.load(l.id));
        unloadedJobLegs.forEach((l) => _pendingJobs.unload(l.id));
        setState(() {});
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              content: Text('Airport not found in OnAir database.\nPlease check the entered ICAO.'),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  void _calculateStats() {
    // Reset
    _totalPayload = 0.0;
    _totalCargo = _routePlan.currentCargo;
    _totalPax = _routePlan.currentPax;
    _totalWeight = 0.0;

    _loadedLegs = _pendingJobs.jobs.map((e) => e.selectedLegs).expand((e) => e).toList();

    // Cargo
    _totalCargo += _loadedLegs.fold(0.0, (sum, l) => sum + l.weight);

    // Pax
    _totalPax += _loadedLegs.fold(0, (sum, l) => sum + l.passengers);
    _overPax = _totalPax > _fleet.activeAircraft.maxSeats;

    // Payload
    _totalPayload += _totalCargo + _totalPax * PAX_WEIGHT + PAX_WEIGHT;

    // Weight
    _totalWeight += _fleet.activeAircraft.emptyWeight + _totalPayload;
    final freeWeight = _fleet.activeAircraft.maxGrossWeight - _totalWeight;
    final fuelCapacity = _fleet.activeAircraft.fuelCapacity * _fleet.activeAircraft.fuel.density;
    final freeFuelWeight = min(freeWeight, fuelCapacity);
    final freeFuelPerc = (freeFuelWeight / fuelCapacity * 100).floor().toDouble();

    // Fuel
    if (freeFuelPerc < 0) {
      _loadedFuelPerc = 0;
    } else if (_loadedFuelPerc > freeFuelPerc) {
      _loadedFuelPerc = freeFuelPerc;
    }
    final fuelWeight = _loadedFuelPerc * _fleet.activeAircraft.fuelCapacity * _fleet.activeAircraft.fuel.density / 100;
    _totalWeight += fuelWeight;
    _overWeight = _totalWeight > _fleet.activeAircraft.maxGrossWeight;
    _addDisabled = (_overWeight || _overPayload || _overPax);

    setState(() {});
  }

  @override
  void initState() {
    _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
    _fleet = Provider.of<Fleet>(context, listen: false);
    _routePlan = Provider.of<RoutePlan>(context, listen: false);
    _settings = Provider.of<Settings>(context, listen: false);
    _pendingJobs.addListener(_calculateStats);
    _fleet.addListener(_calculateStats);
    _routePlan.addListener(_calculateStats);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 75),
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: 4,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'ICAO',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'ICAO missing';
                if (value.length != 4) return 'Invalid ICAO';
              },
              onSaved: (value) => _airportIcao = value!.toUpperCase(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Slider(
              value: _loadedFuelPerc,
              min: 0.0,
              max: 100.0,
              divisions: 100,
              label: 'Fuel loaded: ${_loadedFuelPerc.toInt()}%',
              onChanged: (value) {
                _loadedFuelPerc = value;
                _calculateStats();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Gross weight:'),
              SizedBox(width: 10),
              Text(
                poundsFormat(_totalWeight),
                style: _overWeight ? _errorTextStyle : _okTextStyle,
              ),
              SizedBox(width: 5),
              Text('/'),
              SizedBox(width: 5),
              Text(poundsFormat(_fleet.activeAircraft.maxGrossWeight)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Payload:'),
              SizedBox(width: 10),
              Text(
                poundsFormat(_totalPayload),
                style: _overPayload ? _errorTextStyle : _okTextStyle,
              ),
              SizedBox(width: 5),
              Text('/'),
              SizedBox(width: 5),
              Text(poundsFormat(_fleet.activeAircraft.maxPayloadWeight)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Passengers:'),
              SizedBox(width: 10),
              Text(
                _totalPax.toString(),
                style: _overPax ? _errorTextStyle : _okTextStyle,
              ),
              SizedBox(width: 5),
              Text('/'),
              SizedBox(width: 5),
              Text(_fleet.activeAircraft.maxSeats.toString()),
            ],
          ),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Add new stop to route'),
            ),
            onPressed: _addDisabled ? null : _submit,
          ),
        ],
      ),
    );
  }
}
