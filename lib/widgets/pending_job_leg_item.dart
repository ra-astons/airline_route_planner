import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/string_format.dart';
import '../models/job_leg.dart';
import '../models/pending_jobs.dart';

class PendingJobLegItem extends StatefulWidget {
  final String legId;

  PendingJobLegItem(this.legId);
  @override
  _PendingJobLegItemState createState() => _PendingJobLegItemState();
}

class _PendingJobLegItemState extends State<PendingJobLegItem> {
  @override
  Widget build(BuildContext context) {
    final PendingJobs _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
    final job = _pendingJobs.jobs.firstWhere((j) => j.legs.any((l) => l.id == widget.legId));
    final leg = job.legs.firstWhere((l) => l.id == widget.legId);

    return ChangeNotifierProvider.value(
      value: leg,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
              child: Consumer<JobLeg>(
                builder: (_, jobLeg, ___) {
                  if (jobLeg.isLoaded) {
                    return Checkbox(
                      activeColor: Colors.orangeAccent,
                      checkColor: Colors.orangeAccent,
                      value: true,
                      onChanged: null,
                    );
                  } else if (jobLeg.isComplete) {
                    return Checkbox(
                      value: true,
                      fillColor: MaterialStateProperty.resolveWith((_) => Colors.green),
                      checkColor: Colors.greenAccent,
                      onChanged: null,
                    );
                  } else {
                    return Checkbox(
                      activeColor: Theme.of(context).accentColor,
                      value: jobLeg.isSelected,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _pendingJobs.toggleSelectLeg(jobLeg.id, value);
                          });
                        }
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                leg.departureAirport.icao,
                textAlign: TextAlign.center,
              ),
            ),
            VerticalDivider(),
            SizedBox(
              width: 40,
              child: Text(
                leg.destinationAirport.icao,
                textAlign: TextAlign.center,
              ),
            ),
            VerticalDivider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  leg.description,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ),
            VerticalDivider(),
            SizedBox(
              width: 100,
              child: Text(
                leg.weight == 0 ? '' : poundsFormat(leg.weight),
                textAlign: TextAlign.end,
              ),
            ),
            VerticalDivider(),
            Container(
              padding: EdgeInsets.only(right: 15),
              width: 100,
              child: Text(
                leg.passengers == 0 ? '' : '${leg.passengers} ${leg.seatCategoryString}',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
