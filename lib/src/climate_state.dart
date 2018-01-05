class ClimateState {
  final Map<String, dynamic> _json;

  ClimateState(this._json);

  double get insideTemp => _cToF(_json['inside_temp']);
  double get outsideTemp => _cToF(_json['outside_temp']);
  double get driverTempSetting => _cToF(_json['driver_temp_setting']);
  double get passengerTempSetting => _cToF(_json['passenger_temp_setting']);
  bool get isAutoConditioningOn => _json['is_auto_conditioning_on'];
  bool get isFrontDefrosterOn => _json['is_front_defroster_on'];
  bool get isRearDefrosterOn => _json['is_rear_defroster_on'];
  int get fanStatus => _json['fan_status'];
  double get minAvailTemp => _cToF(_json['min_avail_temp']);
  double get maxAvailTemp => _cToF(_json['max_avail_temp']);
  int get seatHeaterLeft => _json['seat_heater_left'];
  int get seatHeaterRight => _json['seat_heater_right'];
  int get seatHeaterRearLeft => _json['seat_heater_rear_left'];
  int get seatHeaterRearCenter => _json['seat_heater_rear_center'];
  int get seatHeaterRearRight => _json['seat_heater_rear_right'];
  int get seatHeaterRearLeftBack => _json['seat_heater_rear_left_back'];
  int get seatHeaterRearRightBack => _json['seat_heater_rear_right_back'];
  bool get smartPreconditioning => _json['smart_preconditioning'];

  double _cToF(double celsius) =>
      celsius == null ? null : celsius * 9.0 / 5.0 + 32.0;

  String toString() {
    var buffer = new StringBuffer();
    buffer.writeln("Climate State:");
    if (insideTemp != null) {
      buffer.writeln("  Interior Temp:             ${insideTemp}");
    }
    if (outsideTemp != null) {
      buffer.writeln("  Exterior Temp:             ${outsideTemp}");
    }
    buffer.writeln("  Climate Settings:");
    if (isAutoConditioningOn) {
      buffer.writeln("    Mode:                    "
          "${isAutoConditioningOn ? "Auto" : "Manual"}");
    }
    if (fanStatus != null) {
      buffer.writeln("    Fan:                     ${fanStatus}");
    }
    if (driverTempSetting) {
      buffer.writeln("    Driver:                  ${driverTempSetting}");
    }
    if (passengerTempSetting) {
      buffer.writeln("    Passenger:               ${passengerTempSetting}");
    }
    buffer.writeln("  Defrost:");
    buffer.writeln("    Front:                   "
        "${isFrontDefrosterOn ? "On" : "Off"}");
    buffer.writeln("    Rear:                    "
        "${isRearDefrosterOn ? "On" : "Off"}");

    const heaterLevel = const <int, String>{
      0: "Off",
      1: "Low",
      2: "Medium",
      3: "High",
    };
    buffer.writeln("  Seat Heaters:");
    buffer.writeln("    Front Left:              "
        "${heaterLevel[seatHeaterLeft]}");
    buffer.writeln("    Front Right:             "
        "${heaterLevel[seatHeaterRight]}");
    buffer.writeln("    Rear Left:               "
        "${heaterLevel[seatHeaterRearLeft]}");
    buffer.writeln("    Rear Center:             "
        "${heaterLevel[seatHeaterRearCenter]}");
    buffer.writeln("    Rear Right:              "
        "${heaterLevel[seatHeaterRearRight]}");
    buffer.writeln("    Rear Left Back:          "
        "${heaterLevel[seatHeaterRearLeftBack]}");
    buffer.writeln("    Rear Right Back:         "
        "${heaterLevel[seatHeaterRearRightBack]}");
    buffer.writeln("  Smart Preconditioning:     "
        "${smartPreconditioning ? "On" : "Off"}");
    return buffer.toString();
  }

  toJson() => _json;
}
