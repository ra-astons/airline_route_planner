import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pending_jobs.dart';

class NewRouteLeg extends StatefulWidget {
  @override
  _NewRouteLegState createState() => _NewRouteLegState();
}

class _NewRouteLegState extends State<NewRouteLeg> {
  final _formKey = GlobalKey<FormState>();
  late PendingJobs _pendingJobs;

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
            ),
          ),
          ElevatedButton(
            child: Text('Add leg'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
