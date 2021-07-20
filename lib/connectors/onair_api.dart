import 'dart:convert';

import 'package:http/http.dart' as http;

class OnAirApi {
  final String _oaApiKey;
  final String _companyId;

  OnAirApi(this._oaApiKey, this._companyId);

  Future<bool> validateCredentials() async {
    var validCreds = false;
    final response = await http.get(
      Uri.parse('https://thunder.onair.company/api/v1/company/$_companyId'),
      headers: {'oa-apikey': _oaApiKey},
    );
    if (response.statusCode == 200) {
      final json = (jsonDecode(response.body) as Map<String, dynamic>);
      if (!json.containsKey('Error')) {
        validCreds = true;
      }
    }
    return validCreds;
  }
}
