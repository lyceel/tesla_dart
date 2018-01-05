import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'auth.dart';

import 'package:http/http.dart' as http;

class ApiFetcher {
  static const String apiUrl = 'https://owner-api.teslamotors.com';

  static const String authPath = 'oauth/token';
  static const String vehiclesPath = 'api/1/vehicles';
  static const String mobileEnabledPath = 'mobile_enabled';
  static const String chargeStatePath = 'data_request/charge_state';
  static const String climateStatePath = 'data_request/climate_state';
  static const String driveStatePath = 'data_request/drive_state';
  static const String guiSettingsPath = 'data_request/gui_settings';
  static const String vehicleStatePath = 'data_request/vehicle_state';

  static const String wakeUpPath = 'command/wake_up';

  static const String authUrl = '$apiUrl/authPath';
  static const String vehiclesUrl = '$apiUrl/$vehiclesPath';

  Auth _auth;

  bool get isAuthenticated => _auth != null;

  ApiFetcher({Auth auth}) : _auth = auth;

  Future _checkAuth() async {
    if (!isAuthenticated) {
      await _authenticate();
      if (!isAuthenticated) {
        throw new StateError("Failed to load authentication credentials!");
      }
    }
  }

  Future _refreshAuth() async {
    _auth = await _auth.refresh();
    if (_auth == null) {
      throw new StateError("Failed to refresh authentication credentials!");
    }
  }

  Future<String> _get(String url) async {
    await _checkAuth();
    var response = await http
        .get(url, headers: {'Authorization': 'Bearer ${_auth.accessToken}'});
    if (response.statusCode == 401) {
      await _refreshAuth();
      return _get(url);
    }
    if (response.statusCode != 200) {
      throw new StateError("Error during fetch: "
          "(${response.statusCode}) ${response.reasonPhrase}");
    }
    var body = response.body;
    if (body != null && body.isNotEmpty) {
      return body;
    }
    return "";
  }

  Future<Map<String, dynamic>> fetch(String url) async {
    var body = await _get(url);
    var responseData = JSON.decode(body);
    if (responseData is Map && responseData['response'] is Map) {
      return responseData['response'];
    }
    return <String, dynamic>{};
  }

  Future<List<Map<String, dynamic>>> fetchList(String url) async {
    var body = await _get(url);
    if (body != null && body.isNotEmpty) {
      var responseData = JSON.decode(body);
      if (responseData is Map && responseData['response'] is List) {
        return responseData['response'];
      }
    }
    return <Map<String, dynamic>>[];
  }

  Future<bool> fetchBoolean(String url) async {
    var body = await _get(url);
    if (body != null && body.isNotEmpty) {
      var responseData = JSON.decode(body);
      if (responseData is Map && responseData['response'] != null) {
        return responseData['response'];
      }
    }
    return false;
  }

  Future<bool> post(String url) async {
    await _checkAuth();
    var response = await http
        .post(url, headers: {'Authorization': 'Bearer ${_auth.accessToken}'});
    if (response.statusCode == 401) {
      await _refreshAuth();
      return post(url);
    }
    if (response.statusCode != 200) {
      throw new StateError("Error during post: "
          "(${response.statusCode}) ${response.reasonPhrase}");
    }
    var body = response.body;
    if (body != null && body.isNotEmpty) {
      var responseData = JSON.decode(body);
      if (responseData is Map &&
          responseData['response'] != null &&
          responseData['response']['result'] != null) {
        return responseData['response']['result'];
      }
    }
    return false;
  }

  Future _authenticate() async {
    var auth = await Auth.createFromCache(new File('.tesla_auth'));
    if (auth != null) {
      _auth = auth;
      return;
    }
    print("Failed to load auth credentials!");
    _auth = null;
  }
}
