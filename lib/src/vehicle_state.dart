class VehicleState {
  final Map<String, dynamic> _json;

  VehicleState(this._json);

  int get apiVersion => _json['api_version'];
  String get autoparkState => _json['autopark_state'];
  String get autoparkStateV2 => _json['autopark_state_v2'];
  String get autoparkStyle => _json['autopark_style'];
  bool get calendarSupported => _json['calendar_supported'];
  String get carVersion => _json['car_version'];
  int get centerDisplayState => _json['center_display_state'];
  int get driverFrontDoorOpen => _json['df'];
  int get driverRearDoorOpen => _json['dr'];
  int get frontTrunkOpen => _json['ft'];
  bool get homelinkNearby => _json['homelink_nearby'];
  String get lastAutoparkError => _json['last_autopark_error'];
  bool get locked => _json['locked'];
  bool get notificationsSupported => _json['notifications_supported'];
  double get odometer => _json['odometer'];
  bool get parsedCalendarSupported => _json['parsed_calendar_supported'];
  int get passengerFrontDoorOpen => _json['pf'];
  int get passengerRearDoorOpen => _json['pr'];
  bool get remoteStartActive => _json['remote_start'];
  bool get remoteStartSupported => _json['remote_start_supported'];
  int get rearTrunkOpen => _json['rt'];
  int get sunroofPercentOpen => _json['sun_roof_percent_open'];
  String get sunroofState => _json['sun_roof_state'];
  int get timestamp => _json['timestamp'];
  bool get valetMode => _json['valet_mode'];
  bool get valetPinNeeded => _json['valet_pin_needed'];
  String get vehicleName => _json['vehicle_name'];

  String toString() => "Vehicle State:\n"
      "  API Version:              $apiVersion\n"
      "  Configuration:\n"
      "    Car Name:               $vehicleName\n"
      "    Car Version:            $carVersion\n"
      "  Odometer:                 $odometer\n"
      "  Locked:                   ${locked ? "Yes" : "No"}\n"
      "  Doors:\n"
      "    Driver Front:           "
      "${driverFrontDoorOpen == 1 ? "Open" : "Closed"}\n"
      "    Driver Rear:            "
      "${driverRearDoorOpen == 1 ? "Open" : "Closed"}\n"
      "    Passenger Front:        "
      "${passengerFrontDoorOpen == 1 ? "Open" : "Closed"}\n"
      "    Passenger Rear:         "
      "${passengerRearDoorOpen == 1 ? "Open" : "Closed"}\n"
      "    Front Trunk:            ${frontTrunkOpen == 1 ? "Open" : "Closed"}\n"
      "    Rear Trunk:             ${rearTrunkOpen == 1 ? "Open" : "Closed"}\n"
      "  Sunroof:\n"
      "    State:                  $sunroofState\n"
      "    Percent Open:           $sunroofPercentOpen\n"
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
      "${new DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal()}\n";

  toJson() => _json;
}
