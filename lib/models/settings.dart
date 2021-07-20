import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {
  var _oaApiKey = '';
  var _companyId = '';
  var _hideSightSeeing = false;
  var _isLoaded = false;

  String get oaApiKey => _oaApiKey;
  String get companyId => _companyId;
  bool get hideSightSeeing => _hideSightSeeing;
  bool get isLoaded => _isLoaded;

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _oaApiKey = prefs.getString('oa_api_key') ?? '';
    _companyId = prefs.getString('company_id') ?? '';
    _hideSightSeeing = prefs.getBool('hide_sight_seeing') ?? false;
    _isLoaded = true;
  }

  void updateSettings({String? oaApiKey, String? companyId, bool? hideSightSeeing}) async {
    final prefs = await SharedPreferences.getInstance();
    if (oaApiKey != null && _oaApiKey != oaApiKey) {
      await prefs.setString('oa_api_key', oaApiKey);
      _oaApiKey = oaApiKey;
    }
    if (companyId != null && _companyId != companyId) {
      await prefs.setString('company_id', companyId);
      _companyId = companyId;
    }
    if (hideSightSeeing != null && _hideSightSeeing != hideSightSeeing) {
      await prefs.setBool('hide_sight_seeing', hideSightSeeing);
      _hideSightSeeing = hideSightSeeing;
      notifyListeners();
    }
  }
}
