import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/aircraft.dart';
import '../models/airport.dart';
import '../models/job.dart';

class OnAirApiException implements Exception {
  final dynamic message;

  OnAirApiException([this.message]);
}

class OnAirApi {
  final String _oaApiKey;
  final String _companyId;

  OnAirApi(this._oaApiKey, this._companyId);

  Future<Map<String, dynamic>> _get(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: {'oa-apikey': _oaApiKey});
    if (response.statusCode == 404) throw OnAirApiException("Invalid endpoint");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json.containsKey("Error")) throw OnAirApiException(json["Error"]);
      return json;
    } else {
      throw OnAirApiException("API returned ${response.statusCode}");
    }
  }

  Future<bool> validateCredentials() async {
    try {
      final url = 'https://thunder.onair.company/api/v1/company/$_companyId';
      await _get(url);
      return true;
    } on OnAirApiException {
      return false;
    }
  }

  Future<List<Aircraft>> fetchFleet() async {
    final url = 'https://thunder.onair.company/api/v1/company/$_companyId/fleet';
    final json = await _get(url);
    return (json['Content'] as List<dynamic>).map((j) => Aircraft.fromJson(j)).toList();
  }

  Future<List<Job>> fetchPendingJobs() async {
    final url = 'https://thunder.onair.company/api/v1/company/$_companyId/jobs/pending';
    final json = await _get(url);
    return (json['Content'] as List<dynamic>).map((j) => Job.fromJson(j)).toList();
  }

  Future<Airport> fetchAirport(String icao) async {
    final url = 'https://thunder.onair.company/api/v1/airports/$icao';
    final json = await _get(url);
    return Airport.fromJson(json['Content']);
  }
}
