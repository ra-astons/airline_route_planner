import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late PendingJobs _pendingJobs;
  var _airportIcao = '';

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

  @override
  void initState() {
    _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
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
          ElevatedButton(
            child: Text('Add leg'),
            onPressed: _submit,
          )
        ],
      ),
    );
  }
}
