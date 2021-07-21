import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pending_jobs.dart';
import '../screens/settings_screen.dart';

class AppDrawer extends StatefulWidget {
  final String title;

  AppDrawer(this.title);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late PendingJobs _pendingJobs;
  var _showSightSeeing = false;
  var _showCompleted = false;

  @override
  void initState() {
    _pendingJobs = Provider.of<PendingJobs>(context, listen: false);
    _showCompleted = _pendingJobs.completedShown;
    _showSightSeeing = _pendingJobs.sightSeeingShown;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.flight),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text('Show sight-seeing jobs'),
            trailing: Switch(
              value: _showSightSeeing,
              activeColor: theme.accentColor,
              onChanged: (value) {
                setState(() {
                  _showSightSeeing = value;
                });
                _pendingJobs.showSightSeeing(_showSightSeeing);
              },
            ),
          ),
          ListTile(
            title: Text('Show completed legs'),
            trailing: Switch(
              value: _showCompleted,
              activeColor: theme.accentColor,
              onChanged: (value) {
                setState(() {
                  _showCompleted = value;
                });
                _pendingJobs.showCompleted(_showCompleted);
              },
            ),
          ),
          Expanded(child: Container()),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.pushNamed(SettingsScreen.routeName);
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
