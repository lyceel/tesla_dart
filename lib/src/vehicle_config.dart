class VehicleConfig {
  final Map<String, dynamic> _json;

  VehicleConfig(this._json);

  bool get canAcceptNavRequests => _json['can_accept_navigation_requests'];
  bool get canActuateTrunks => _json['can_actuate_trunks'];
  String get carType => _json['car_type'];
  String get chargePortType => _json['charge_port_type'];
  bool get euVehicle => _json['eu_vehicle'];
  String get exteriorColor => _json['exterior_color'];
  bool get hasAirSuspension => _json['has_air_suspension'];
  bool get hasLudicrousMode => _json['has_ludicrous_mode'];
  bool get motorizedChargePort => _json['motorized_charge_port'];
  String get performanceConfig => _json['perf_config'];
  bool get powerLiftGate => _json['plg'];
  int get rearSeatHeaters => _json['rear_seat_heaters'];
  int get rearSeatType => _json['rear_seat_type'];
  bool get rightHandDrive => _json['rhd'];
  String get roofColor => _json['roof_color'];
  int get seatType => _json['seat_type'];
  String get spoilerType => _json['spoiler_type'];
  int get sunroofInstalled => _json['sun_roof_installed'];
  String get thirdRowSeats => _json['third_row_seats'];
  String get trimBadging => _json['trim_badging'];
  String get wheelType => _json['wheel_type'];
  int get timestamp => _json['timestamp'];

  String toString() => "  Car Type: $carType\n"
      "  Trim Badging: ${trimBadging.toUpperCase()}\n"
      "  Exterior Color: $exteriorColor\n"
      "  Roof Color: $roofColor\n"
      "\n"
      "  Localization:\n"
      "    Driver Side: ${rightHandDrive ? "Right" : "Left"}\n"
      "    Charge Port: $chargePortType\n"
      "    EU Vehicle: ${euVehicle ? "Yes" : "No"}\n"
      "\n"
      "  Features:"
      "\n"
      "    Seats:\n"
      "      Front:   $seatType\n"
      "      Rear:    $rearSeatType\n"
      "      3rd Row: $thirdRowSeats\n"
      "\n"
      "    Sunroof:        ${sunroofInstalled != 0 ? "Yes" : "No"}\n"
      "    Wheels:         $wheelType\n"
      "    Spoiler:        $spoilerType\n"
      "    Air Suspension: ${hasAirSuspension ? "Yes" : "No"}\n"
      "    Motorized Charge Port: ${motorizedChargePort ? "Yes" : "No"}\n"
      "    Power Lift Gate:       ${powerLiftGate ? "Yes" : "No"}\n"
      "\n"
      "  Performance:\n"
      "    Performance Config: $performanceConfig\n"
      "    Ludicrous Mode:     ${hasLudicrousMode ? "Yes" : "No"}\n"
      "\n"
      "  Remote Control:\n"
      "    Accept Navigation Requests: ${canAcceptNavRequests ? "Yes" : "No"}\n"
      "    Actuate Trunks:             ${canActuateTrunks ? "Yes" : "No"}\n";

  toJson() => _json;
}
