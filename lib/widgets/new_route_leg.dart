import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/constants.dart';
import '../helpers/string_format.dart';
import '../models/fleet.dart';
import '../models/job_leg.dart';
import '../models/pending_jobs.dart';
import '../models/route_leg.dart';
import '../models/route_plan.dart';

class NewRouteLeg extends StatefulWidget {
  @override
  _NewRouteLegState createState() => _NewRouteLegState();
}

class _NewRouteLegState extends State<NewRouteLeg> {
  final _formKey = GlobalKey<FormState>();
  final _okTextStyle = TextStyle(color: Colors.white);
  final _errorTextStyle = TextStyle(color: Colors.red);
  late PendingJobs _pendingJobs;
  late Fleet _fleet;
  var _airportIcao = '';
  var _loadedFuelPerc = 100.0;
  var _totalWeight = 0.0;
  var _totalPayload = 0.0;
  var _totalPax = 0;
  var _overWeight = false;
  var _overPayload = false;
  var _overPax = false;
  List<JobLeg> _loadedLegs = [];

  void _submit() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final List<JobLeg> jobLegs = [];
      _pendingJobs.jobs.forEach((j) {
        jobLegs.addAll(j.selectedLegs);
        jobLegs.forEach((l) => l.load());
      });
      final routePlan = Provider.of<RoutePlan>(context, listen: false);
      routePlan.addRouteLeg(RouteLeg(_airportIcao, jobLegs, 100));
    }
  }

  void _calculateStats() {
    // Reset
    _totalPayload = 0.0;
    _totalPax = 0;
    _totalWeight = 0.0;

    // Payload
    _loadedLegs = _pendingJobs.jobs.map((e) => e.selectedLegs).expand((e) => e).toList();
    _totalPayload += _loadedLegs.fold(0.0, (sum, l) => sum + l.weight);
    _totalPayload += _loadedLegs.fold(0.0, (sum, l) => sum + l.passengers * PAX_WEIGHT);
    _totalPayload += PAX_WEIGHT; // Pilot

    // Pax
    _totalPax += _loadedLegs.fold(0, (sum, l) => sum + l.passengers);
    _overPax = _totalPax > _fleet.activeAircraft.maxSeats;

    // Weight
    _totalWeight += _fleet.activeAircraft.emptyWeight + _totalPayload;
    final freeWeight = _fleet.activeAircraft.maxGrossWeight - _totalWeight;
    final fuelCapacity = _fleet.activeAircraft.fuelCapacity * _fleet.activeAircraft.fuel.density;
    final freeFuelWeight = min(freeWeight, fuelCapacity);
    final freeFuelPerc = (freeFuelWeight / fuelCapacity * 100).floor().toDouble();

    // Fuel
    if (_loadedFuelPerc > freeFuelPerc) _loadedFuelPerc = freeFuelPerc;
    final fuelWeight = _loadedFuelPerc * _fleet.activeAircraft.fuelCapacity * _fleet.activeAircraft.fuel.density / 100;
    _totalWeight += fuelWeight;

    setState(() {});
  }

  @override
  void initState() {
    _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
    _fleet = Provider.of<Fleet>(context, listen: false);
    _pendingJobs.addListener(_calculateStats);
    _fleet.addListener(_calculateStats);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 100,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'ICAO',
              ),
              onChanged: (value) {
                _pendingJobs.filterByDeparture(value.toUpperCase());
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'ICAO missing';
                if (value.length != 4) return 'Invalid ICAO';
              },
              onSaved: (value) => _airportIcao = value!.toUpperCase(),
            ),
          ),
          Container(
            width: 320,
            child: Slider(
                value: _loadedFuelPerc,
                min: 0.0,
                max: 100.0,
                divisions: 100,
                label: '${_loadedFuelPerc.toInt()}%',
                onChanged: (value) {
                  _loadedFuelPerc = value;
                  _calculateStats();
                }),
          ),
          VerticalDivider(),
          Container(
            child: Row(
              children: [
                Text('Gross weight:', style: _overWeight ? _errorTextStyle : _okTextStyle),
                SizedBox(
                  width: 10,
                ),
                Text(poundsFormat(_totalWeight), style: _overWeight ? _errorTextStyle : _okTextStyle),
                Text('/', style: _overWeight ? _errorTextStyle : _okTextStyle),
                Text(poundsFormat(_fleet.activeAircraft.maxGrossWeight),
                    style: _overWeight ? _errorTextStyle : _okTextStyle),
              ],
            ),
          ),
          VerticalDivider(),
          Container(
            child: Row(
              children: [
                Text('Payload:', style: _overPayload ? _errorTextStyle : _okTextStyle),
                SizedBox(
                  width: 10,
                ),
                Text(poundsFormat(_totalPayload), style: _overPayload ? _errorTextStyle : _okTextStyle),
                Text('/', style: _overPayload ? _errorTextStyle : _okTextStyle),
                Text(poundsFormat(_fleet.activeAircraft.maxPayloadWeight),
                    style: _overPayload ? _errorTextStyle : _okTextStyle),
              ],
            ),
          ),
          VerticalDivider(),
          Container(
            child: Row(
              children: [
                Text('Passengers:', style: _overPax ? _errorTextStyle : _okTextStyle),
                SizedBox(
                  width: 10,
                ),
                Text(_totalPax.toString(), style: _overPax ? _errorTextStyle : _okTextStyle),
                Text('/', style: _overPax ? _errorTextStyle : _okTextStyle),
                Text(_fleet.activeAircraft.maxSeats.toString(), style: _overPax ? _errorTextStyle : _okTextStyle),
              ],
            ),
          ),
          VerticalDivider(),
          ElevatedButton(
            child: Text('Add leg'),
            onPressed: _submit,
          )
        ],
      ),
    );
  }
}
