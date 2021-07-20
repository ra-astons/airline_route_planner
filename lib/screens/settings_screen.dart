import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../connectors/onair_api.dart';
import '../models/pending_jobs.dart';
import '../models/settings.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late Settings _settings;
  var _oaApiKey = '';
  var _companyId = '';
  var _hideSightSeeing = false;

  String? _validateOaKey(String? key) {
    final oaKeyRegExp = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');
    if (key == null || key.isEmpty) return 'Field is mandatory';
    if (!oaKeyRegExp.hasMatch(key)) return 'Key format is not valid';
  }

  void _showInvalidCredsDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Text('These credentials don\'t seem to be valid.\nPlease check again.'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        );
      },
    );
  }

  void _submit() async {
    if (_formKey.currentState == null) return;
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    if (_oaApiKey != _settings.oaApiKey || _companyId != _settings.companyId) {
      final onAir = OnAirApi(_oaApiKey, _companyId);
      if (!await onAir.validateCredentials()) {
        _showInvalidCredsDialog();
        return;
      }
      _settings.updateSettings(oaApiKey: _oaApiKey, companyId: _companyId);
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
    if (_hideSightSeeing != _settings.hideSightSeeing) {
      _settings.updateSettings(hideSightSeeing: _hideSightSeeing);
      final pendingJobs = Provider.of<PendingJobs>(context, listen: false);
      pendingJobs.hideSightSeeing(_hideSightSeeing);
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _settings = Provider.of<Settings>(context, listen: false);
    _oaApiKey = _settings.oaApiKey;
    _companyId = _settings.companyId;
    _hideSightSeeing = _settings.hideSightSeeing;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          width: 350,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _oaApiKey,
                  decoration: InputDecoration(labelText: 'OnAir API key'),
                  validator: _validateOaKey,
                  onSaved: (value) => _oaApiKey = value!,
                ),
                TextFormField(
                  initialValue: _companyId,
                  decoration: InputDecoration(labelText: 'OnAir Company ID'),
                  validator: _validateOaKey,
                  onSaved: (value) => _companyId = value!,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hide sight-seeing jobs'),
                    Switch(
                      value: _hideSightSeeing,
                      onChanged: (value) {
                        setState(() {
                          _hideSightSeeing = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: _submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
