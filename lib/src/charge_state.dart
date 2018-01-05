import 'package:ansicolor/ansicolor.dart';

class ChargeState {
  final Map<String, dynamic> _json;
  final int batterySize;

  ChargeState(this._json, this.batterySize);

  String get chargingState => _json['charging_state'];
  int get chargeLimitSoc => _json['charge_limit_soc'];
  int get chargeLimitSocStd => _json['charge_limit_soc_std'];
  int get chargeLimitSocMin => _json['charge_limit_soc_min'];
  int get chargeLimitSocMax => _json['charge_limit_soc_max'];
  bool get chargeToMaxRange => _json['charge_to_max_range'];
  int get maxRangeChargeCounter => _json['max_range_charge_counter'];
  bool get fastChargerPresent => _json['fast_charger_present'];
  String get fastChargerType => _json['fast_charger_type'];
  double get batteryRange => _json['battery_range'];
  double get estBatteryRange => _json['est_battery_range'];
  double get idealBatteryRange => _json['ideal_battery_range'];
  int get batteryLevel => _json['battery_level'];
  int get usableBatteryLevel => _json['usable_battery_level'];
  double get batteryCurrent => _json['battery_current'];
  double get chargeEnergyAdded => _json['charge_energy_added'];
  double get chargeMilesAddedRated => _json['charge_miles_added_rated'];
  double get chargeMilesAddedIdeal => _json['charge_miles_added_ideal'];
  int get chargerVoltage => _json['charger_voltage'];
  int get chargerPilotCurrent => _json['charger_pilot_current'];
  int get chargerActualCurrent => _json['charger_actual_current'];
  int get chargerPower => _json['charger_power'];
  double get timeToFullCharge => _json['time_to_full_charge'];
  bool get tripCharging => _json['trip_charging'];
  double get chargeRate => _json['charge_rate'];
  bool get chargePortDoorOpen => _json['charge_port_door_open'];
  bool get userChargeEnableRequest => _json['user_charge_enable_request'];
  bool get chargeEnableRequest => _json['charge_enable_request'];
  String get chargerPhases => _json['charger_phases'];
  String get chargePortLatch => _json['charge_port_latch'];
  int get chargeCurrentRequest => _json['charge_current_request'];
  int get chargeCurrentRequestMax => _json['charge_current_request_max'];
  bool get managedChargingActive => _json['managed_charging_active'];
  bool get managedChargingUserCanceled =>
      _json['managed_charging_user_canceled'];
  int get managedChargingStartTime => _json['managed_charging_start_time'];
  bool get motorizedChargePort => _json['motorized_charge_port'];
  bool get euVehicle => _json['eu_vehicle'];
  int get timestamp => _json['timestamp'];

  List<String> renderBattery(int level) {
    const top = '╭──────────╮';
    const left = '│';
    const right = '▐';
    const bottom = '╰──────────╯';
    const fullBlock = '█';
    const partialBlocks = const [
      ' ',
      '▏',
      '▎',
      '▍',
      '▍',
      '▌',
      '▋',
      '▊',
      '▊',
      '▉'
    ];

    var fullBlocks = level ~/ 10;
    var partialBlockIndex = level % 10;

    var pen = new AnsiPen();
    if (level < 10) {
      pen.red();
    } else if (level < 25) {
      pen.yellow();
    } else {
      pen.green();
    }

    var middle = left +
        pen((fullBlock * fullBlocks) +
        (fullBlocks < 10 ? partialBlocks[partialBlockIndex] : '') +
        (fullBlocks < 10 ? ' ' * (10 - fullBlocks - 1) : '')) +
        right;

    return [top, middle, bottom];
  }

  String toString() {
    var buffer = new StringBuffer();
    var batteryEnergy = (batteryLevel * batterySize) / 100.0;
    buffer.writeln("  Battery:         $batteryEnergy/$batterySize.0 kWh "
        "($batteryLevel%)");
    var battLines = renderBattery(batteryLevel);
    buffer.writeln("                   ${battLines[0]}");
    buffer.writeln("                   ${battLines[1]}");
    buffer.writeln("                   ${battLines[2]}");
    buffer.writeln("  Range:           $batteryRange miles");
    var charging = chargingState == "Charging";
    buffer.write("  Charge state:    ");
    if (charging) {
      buffer.writeln("$chargingState to $chargeLimitSoc%");
    } else if (chargingState == null) {
      buffer.writeln("Disconnected");
    } else {
      buffer.writeln("$chargingState");
    }
    if (charging) {
      buffer.writeln("    Voltage:       $chargerVoltage V");
      buffer.writeln("    Current:       "
          "$chargerActualCurrent/$chargerPilotCurrent A");
      buffer.writeln("    Power:         $chargerPower kW");
      buffer.writeln("    Rate:          $chargeRate mi/h");
    }
    if (chargingState == 'Charging' || chargingState == 'Complete') {
      buffer.writeln("    Added:         "
          "$chargeMilesAddedRated mi, $chargeEnergyAdded kWh");
    }
    if (chargingState == 'Charging') {
      var hours = timeToFullCharge.toInt();
      var minutes = ((timeToFullCharge - hours) * 60).toInt();
      buffer.writeln("    Remaining:     ${hours}h ${minutes}m");
    }
    return buffer.toString();
  }

  toJson() => _json;
}
