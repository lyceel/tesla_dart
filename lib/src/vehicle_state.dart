class VehicleState {
  final Map<String, dynamic> _json;

  VehicleState(this._json);

  int get apiVersion => _json['api_version'];
  String get autoparkState => _json['autopark_state'];
  String get autoparkStateV2 => _json['autopark_state_v2'];
  String get autoparkStyle => _json['autopark_style'];
  bool get calendarSupported => _json['calendar_supported'];
  String get carType => _json['car_type'];
  String get carVersion => _json['car_version'];
  int get centerDisplayState => _json['center_display_state'];
  bool get darkRims => _json['dark_rims'];
  bool get driverFrontDoorOpen => _json['df'];
  bool get driverRearDoorOpen => _json['dr'];
  String get exteriorColor => _json['exterior_color'];
  bool get frontTrunkOpen => _json['ft'];
  bool get hasSpoiler => _json['has_spoiler'];
  bool get homelinkNearby => _json['homelink_nearby'];
  String get lastAutoparkError => _json['last_autopark_error'];
  bool get locked => _json['locked'];
  bool get notificationsSupported => _json['notifications_supported'];
  double get odometer => _json['odometer'];
  bool get parsedCalendarSupported => _json['parsed_calendar_supported'];
  String get perfConfig => _json['perf_config'];
  int get rearSeatHeaters => _json['rear_seat_heaters'];
  int get rearSeatType => _json['rear_seat_type'];
  bool get remoteStartActive => _json['remote_start'];
  bool get remoteStartSupported => _json['remote_start_supported'];
  bool get rightHandDrive => _json['rhd'];
  String get roofColor => _json['roof_color'];
  bool get rearTrunkOpen => _json['rt'];
  int get seatType => _json['seat_type'];
  String get spoilerType => _json['spoiler_type'];
  bool get sunroofInstalled => _json['sun_roof_installed'];
  bool get sunroofPercentOpen => _json['sun_roof_percent_open'];
  String get sunroofState => _json['sun_roof_state'];
  String get thirdRowSeats => _json['third_row_seats'];
  int get timestamp => _json['timestamp'];
  bool get valetMode => _json['valet_mode'];
  bool get valetPinNeeded => _json['valet_pin_needed'];
  bool get passengerFrontDoorOpen => _json['pf'];
  bool get passengerRearDoorOpen => _json['pr'];
  String get wheelType => _json['wheel_type'];

  String toString() => "Vehicle State:\n"
      "  API Version:              $apiVersion\n"
      "  Configuration:\n"
      "    Car Type:               $carType\n"
      "    Car Version:            $carVersion\n"
      "    Exterior Color:         $exteriorColor\n"
      "    Roof Color:             $roofColor\n"
      "    Wheel Type:             $wheelType\n"
      "    Dark Rims:              $darkRims\n"
      "    Spoiler:\n"
      "      Installed:            ${hasSpoiler ? "Yes" : "No"}\n"
      "      Type:                 $spoilerType\n"
      "    Performance Config:     $perfConfig\n"
      "    Drive Orientation:      "
      "${rightHandDrive ? "Right-hand" : "Left-hand"}\n"
      "    Sunroof:\n"
      "      Installed:            $sunroofInstalled\n"
      "      State:                $sunroofState\n"
      "      Percent Open:         $sunroofPercentOpen\n"
      "    Seat Types:\n"
      "      Front:                $seatType\n"
      "      Rear:                 $rearSeatType\n"
      "      Third Row:            $thirdRowSeats\n"
      "    Rear Seat Heaters:      ${rearSeatHeaters == 0 ? "No" : "Yes"}\n"
      "  Odometer:                 $odometer\n"
      "  Locked:                   ${locked ? "Yes" : "No"}\n"
      "  Doors:\n"
      "    Driver Front:           ${driverFrontDoorOpen ? "Open" : "Closed"}\n"
      "    Driver Rear:            ${driverRearDoorOpen ? "Open" : "Closed"}\n"
      "    Passenger Front:        "
      "${passengerFrontDoorOpen ? "Open" : "Closed"}\n"
      "    Passenger Rear:         "
      "${passengerRearDoorOpen ? "Open" : "Closed"}\n"
      "    Front Trunk:            ${frontTrunkOpen ? "Open" : "Closed"}\n"
      "    Rear Trunk:             ${rearTrunkOpen ? "Open" : "Closed"}\n"
      "  Center Display State:     $centerDisplayState\n"
      "  Calendar\n"
      "    Supported:              $calendarSupported\n"
      "    Parsed:                 $parsedCalendarSupported\n"
      "  Notification Support:     $notificationsSupported\n"
      "  Homelink Nearby:          $homelinkNearby\n"
      "  Autopark:\n"
      "    Current State:          v1: $autoparkState\n"
      "                            v2: $autoparkStateV2\n"
      "    Style:                  $autoparkStyle\n"
      "    Last Error:             $lastAutoparkError\n"
      "  Remote Start:\n"
      "    Supported:              $remoteStartSupported\n"
      "    Active:                 $remoteStartActive\n"
      "  Valet Mode:\n"
      "    Active:                 $valetMode\n"
      "    PIN Needed:             $valetPinNeeded\n"
      "  Timestamp:                "
      "${new DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true)
              .toLocal()}\n";

  toJson() => _json;
}
