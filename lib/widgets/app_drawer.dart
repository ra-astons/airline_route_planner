import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  final String title;

  AppDrawer(this.title);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.flight),
                ),
                Text(
                  title,
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
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              final navigator = Navigator.of(context);
              navigator.pop();
              navigator.pushNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
