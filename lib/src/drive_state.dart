class DriveState {
  final Map<String, dynamic> _json;

  DriveState(this._json);

  String get shiftState => _json['shift_state'];
  int get speed => _json['speed'];
  double get latitude => _json['latitude'];
  double get longitude => _json['longitude'];
  int get heading => _json['heading'];
  int get gpsAsOf => _json['gps_as_of'];
  int get power => _json['power'];

  String get compassDirection {
    const interval = 22.5;
    const directions = <String>[
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW'
    ];

    double left = 0.0;
    double right = left + interval / 2.0;
    for (var direction in directions) {
      if (heading >= left && heading < right) {
        return direction;
      }
      left = right;
      right += interval;
    }

    // If we get here, we've gone all the way around, and we must be in
    // the [348.75, 360.0) interval.
    return 'N';
  }

  String toString() =>
      "  Shift state: ${shiftState == null ? "Car Off" : shiftState}\n"
      "  Position:    $latitude, $longitude (as of "
      "${_renderTimestamp(gpsAsOf * 1000)})\n"
      "  Heading:     $heading ($compassDirection)\n"
      "  Speed:       ${speed == null ? 0 : speed}\n"
      "  Power:       $power kW\n";

  String _renderTimestamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true)
          .toLocal()
          .toString();

  toJson() => _json;
}
