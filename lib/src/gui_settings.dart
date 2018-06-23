class GuiSettings {
  final Map<String, dynamic> _json;

  GuiSettings(this._json);

  String get distanceUnits => _json['gui_distance_units'];
  String get temperatureUnits => _json['gui_temperature_units'];
  String get chargeRateUnits => _json['gui_charge_rate_units'];
  bool get twentyFourHourTime => _json['gui_24_hour_time'];
  String get rangeDisplay => _json['gui_range_display'];
  int get timestamp => _json['timestamp'];

  String toString() => '''
GUI Settings:
  Units:
    Distance:       $distanceUnits
    Temperature:    ${temperatureUnits == 'F' ? "Fahrenheit" : "Celsius"}
    Charge Rate:    $chargeRateUnits
  Time Display:     ${twentyFourHourTime ? "24-hour" : "12-hour"}
  Range Display:    $rangeDisplay
  Timestamp:        ${new DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal()}
''';
  toJson() => _json;
}
