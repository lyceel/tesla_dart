class GuiSettings {
  final Map<String, dynamic> _json;

  GuiSettings(this._json);

  String? get distanceUnits => _json['gui_distance_units'];
  String? get temperatureUnits => _json['gui_temperature_units'];
  String? get chargeRateUnits => _json['gui_charge_rate_units'];
  bool? get twentyFourHourTime => _json['gui_24_hour_time'];
  String? get rangeDisplay => _json['gui_range_display'];
  int? get timestamp => _json['timestamp'];

  String toString() => 'GUI Settings:\n'
      '  Units:\n'
      '    Distance:       $distanceUnits\n'
      '    Temperature:    '
      '${temperatureUnits == 'F' ? 'Fahrenheit' : 'Celsius'}\n'
      '    Charge Rate:    $chargeRateUnits\n'
      '  Time Display:     '
          '${(twentyFourHourTime ?? false) ? '24-hour' : '12-hour'}\n'
      '  Range Display:    $rangeDisplay\n'
      '  Timestamp:        ${_renderTimestamp(timestamp ?? 0)}\n';

  toJson() => _json;

  String _renderTimestamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true)
          .toLocal()
          .toString();
}
