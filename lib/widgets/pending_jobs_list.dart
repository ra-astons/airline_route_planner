import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pending_job_leg_item.dart';
import '../models/pending_jobs.dart';
import '../models/settings.dart';

class PendingJobsList extends StatefulWidget {
  @override
  _PendingJobsListState createState() => _PendingJobsListState();
}

class _PendingJobsListState extends State<PendingJobsList> {
  var _isInit = true;
  late PendingJobs _pendingJobs;
  late Settings _settings;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
      _settings = Provider.of<Settings>(context);
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _displayedJobs =
        _settings.hideSightSeeing ? _pendingJobs.jobs.where((j) => !j.hasSightSeeingLeg).toList() : _pendingJobs.jobs;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Card(
        elevation: 5,
        child: ListView.builder(
          itemCount: _displayedJobs.length,
          itemBuilder: (_, index) {
            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        _displayedJobs[index].description,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 2,
                ),
                ..._displayedJobs[index].legs.map((leg) {
                  return Column(
                    children: [
                      PendingJobLegItem(leg.id),
                      Divider(
                        height: 2,
                      ),
                    ],
                  );
                }).toList(),
                SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}
