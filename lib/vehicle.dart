import 'dart:async';
import 'dart:math';

import 'src/api_fetcher.dart';
import 'src/option_names.dart';
import 'src/charge_state.dart';
import 'src/climate_state.dart';
import 'src/drive_state.dart';
import 'src/gui_settings.dart';
import 'src/vehicle_state.dart';

class Vehicle {
  final VehicleSummary summary;
  final ApiFetcher fetcher;
  bool _isMobileEnabled;

  ChargeState _chargeState;
  ClimateState _climateState;
  DriveState _driveState;
  GuiSettings _guiSettings;
  VehicleState _vehicleState;

  Vehicle._(this.summary, this.fetcher, this._isMobileEnabled);

  bool get isMobileEnabled => _isMobileEnabled;
  ChargeState get chargeState => _chargeState;
  ClimateState get climateState => _climateState;
  DriveState get driveState => _driveState;
  GuiSettings get guiSettings => _guiSettings;
  VehicleState get vehicleState => _vehicleState;

  String toString() => summary.toString();

  static Future<List<Vehicle>> getVehicles(ApiFetcher fetcher) async {
    var response = await fetcher.fetchList(ApiFetcher.vehiclesUrl);
    var result = <Vehicle>[];
    if (response != null) {
      var rand = new Random();
      Future<bool> _fetchMobileFor(int id) async {
        try {
          var mobileEnabled =
              await fetcher.fetchBoolean('${ApiFetcher.vehiclesUrl}/$id/'
                  '${ApiFetcher.mobileEnabledPath}');
          return mobileEnabled;
        } catch (e) {
          if (e is int && e == 408) {
            var time = rand.nextDouble() * 5000;
            var delay = new Duration(milliseconds: time.toInt());
            print("Timeout error fetching mobile-enabled; retry in $delay");
            await new Future.delayed(delay);
            return _fetchMobileFor(id);
          }
          rethrow;
        }
      }

      for (var vehicle in response) {
        var summary = new VehicleSummary(vehicle);
        var mobileEnabled = await _fetchMobileFor(summary.id);
        result.add(new Vehicle._(summary, fetcher, mobileEnabled));
      }
    }
    return result;
  }

  Future updateChargeState() async {
    var response =
        await fetcher.fetch('${ApiFetcher.vehiclesUrl}/${summary.id}/'
            '${ApiFetcher.chargeStatePath}');
    _chargeState = new ChargeState(response, summary.batterySize);
  }

  Future updateClimateState() async {
    var response =
        await fetcher.fetch('${ApiFetcher.vehiclesUrl}/${summary.id}/'
            '${ApiFetcher.climateStatePath}');
    _climateState = new ClimateState(response);
  }

  Future updateDriveState() async {
    var response =
        await fetcher.fetch('${ApiFetcher.vehiclesUrl}/${summary.id}/'
            '${ApiFetcher.driveStatePath}');
    _driveState = new DriveState(response);
  }

  Future updateGuiSettings() async {
    var response =
        await fetcher.fetch('${ApiFetcher.vehiclesUrl}/${summary.id}/'
            '${ApiFetcher.guiSettingsPath}');
    _guiSettings = new GuiSettings(response);
  }

  Future updateVehicleState() async {
    var response =
        await fetcher.fetch('${ApiFetcher.vehiclesUrl}/${summary.id}/'
            '${ApiFetcher.vehicleStatePath}');
    _vehicleState = new VehicleState(response);
  }

  Future<bool> wakeUp() async {
    var response = await fetcher.post(
        '${ApiFetcher.vehiclesUrl}/${summary.id}/${ApiFetcher.wakeUpPath}');
    return response;
  }
}

class VehicleSummary {
  final Map<String, dynamic> _json;
  final Map<String, List<String>> options = {};
  int _batterySize = 0;

  VehicleSummary(this._json) {
    _decodeOptions();
    _decodeBatterySize();
  }

  int get id => _json['id'];
  int get vehicleId => _json['vehicle_id'];
  String get vin => _json['vin'];
  String get displayName => _json['display_name'];
  String get optionCodes => _json['option_codes'];
  String get color => _json['color'];
  List<String> get tokens => _json['tokens'];
  String get state => _json['state'];
  bool get inService => _json['in_service'];
  String get idS => _json['id_s'];
  bool get remoteStartEnabled => _json['remote_start_enabled'];
  bool get calendarEnabled => _json['calendar_enabled'];
  String get backseatToken => _json['backseat_token'];
  int get backseatTokenUpdatedAt => _json['backseat_token_updated_at'];
  int get batterySize => _batterySize;

  void _decodeOptions() {
    var optionList = optionCodes.split(',');
    for (var option in optionList) {
      var optionValue = optionDecoder[option];
      if (optionValue != null) {
        var category = optionValue['category'];
        if (!options.containsKey(category)) {
          options[category] = <String>[];
        }
        options[category].add(optionValue['name']);
      }
    }
  }

  void _decodeBatterySize() {
    const noBatterySize = 100000000;
    const batterySizes = const <String, int>{
      'BR03': 60,
      'BR05': 75,
      'BT40': 40,
      'BT60': 60,
      'BT70': 70,
      'BT85': 85,
      'BTX4': 90,
      'BTX5': 75,
      'BTX6': 100,
      'BTX7': 75,
      'BTX8': 85,
    };

    var size = noBatterySize;
    var codes = optionCodes.split(',');
    for (var code in codes) {
      if (batterySizes.containsKey(code) && batterySizes[code] < size) {
        size = batterySizes[code];
      }
    }
    if (size < noBatterySize) {
      _batterySize = size;
    } else {
      _batterySize = 0;
    }
  }

  String toString() => '$vehicleId: "$displayName" (VIN: $vin)';

  String optionsList() {
    var buffer = new StringBuffer();
    buffer.writeln("Configuration:");
    for (var category in categoryNames.keys) {
      if (options.containsKey(category)) {
        buffer.writeln("  ${categoryNames[category]}:");
        for (var option in options[category]) {
          buffer.writeln("    $option");
        }
        buffer.writeln("");
      }
    }
    return buffer.toString();
  }

  toJson() => _json;
}
