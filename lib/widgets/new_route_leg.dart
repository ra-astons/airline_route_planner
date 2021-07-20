import 'package:flutter/material.dart';

class NewRouteLeg extends StatefulWidget {
  @override
  _NewRouteLegState createState() => _NewRouteLegState();
}

class _NewRouteLegState extends State<NewRouteLeg> {
  final _formKey = GlobalKey<FormState>();

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
