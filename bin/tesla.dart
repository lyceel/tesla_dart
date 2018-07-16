import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'package:tesla/src/api_fetcher.dart';
import 'package:tesla/src/auth.dart';
import 'package:tesla/vehicle.dart';

Future main(List<String> args) async {
  var argParser = new ArgParser()
    ..addFlag('raw', defaultsTo: false, help: 'dumps raw information')
    ..addFlag('show-options',
        abbr: 'o',
        defaultsTo: false,
        help: 'decodes the VIN to print off options')
    ..addFlag('show-charge',
        abbr: 'c', defaultsTo: true, help: 'current state of charge')
    ..addFlag('show-climate',
        abbr: 'l',
        defaultsTo: false,
        help: 'the current climate settings and measured temperatures')
    ..addFlag('show-drive',
        abbr: 'd',
        defaultsTo: false,
        help: 'current location, heading, speed, gear, and power usage')
    ..addFlag('show-gui',
        abbr: 'g', defaultsTo: false, help: 'user preferences (mph/kph, etc)')
    ..addFlag('show-vehicle',
        abbr: 'v',
        defaultsTo: false,
        help: 'vehicle state (software verion, name, doors, etc)')
    ..addFlag('show-all', defaultsTo: false, help: 'shows all settings')
    ..addFlag('help', abbr: 'h', help: 'prints this help')
    ..addOption('access-token', abbr: 'a');

  var results = argParser.parse(args);

  if (results.wasParsed('help')) {
    stderr.writeln("tesla.dart");
    for (var line in LineSplitter.split(argParser.usage)) {
      stderr.writeln("   $line");
    }
    await stderr.flush();
    return;
  }
  var raw = results['raw'];
  var showOptions = results['show-options'];
  var showCharge = results['show-charge'];
  var showClimate = results['show-climate'];
  var showDrive = results['show-drive'];
  var showGui = results['show-gui'];
  var showVehicle = results['show-vehicle'];
  if (results['show-all']) {
    showOptions = true;
    showCharge = true;
    showClimate = true;
    showDrive = true;
    showGui = true;
    showVehicle = true;
  }

  var fetcher = new ApiFetcher(
      auth: results.wasParsed('access-token')
          ? new Auth({'access_token': results['access-token']})
          : null);

  var vehicles = await Vehicle.getVehicles(fetcher);
  var car = vehicles.first;

  print("Waking car up...");
  var awake = await car.wakeUp();
  if (!awake) {
    print("Failed to wake up car. Some data might be missing!");
  }
  print("${car.summary}");
  if (showOptions) {
    print("${car.summary.optionsList()}");
  }
  if (raw) {
    print("\n  raw: "
        "${car.summary.toJson().toString().replaceAll(", ", "\n    ")}");
  }

  if (showCharge) {
    await car.updateChargeState();
    print("Charge State:");
    if (raw) {
      print("\n  raw: "
          "${car.chargeState.toJson().toString().replaceAll(", ", "\n    ")}");
    }
    print("${car.chargeState}");
  }

  if (showClimate) {
    await car.updateClimateState();
    print("Climate State:");
    if (raw) {
      print("raw: "
          "${car.climateState.toJson().toString().replaceAll(", ", "\n    ")}");
    }
    print("${car.climateState}");
  }

  if (showDrive) {
    await car.updateDriveState();
    print("Drive State:");
    if (raw) {
      print("\n  raw: "
          "${car.driveState.toJson().toString().replaceAll(", ", "\n    ")}");
    }
    print("${car.driveState}");
  }

  if (showGui) {
    await car.updateGuiSettings();
    print("GUI Settings:");
    if (raw) {
      print("\n  raw: "
          "${car.guiSettings.toJson().toString().replaceAll(", ", "\n    ")}");
    }
    print("${car.guiSettings}");
  }

  if (showVehicle) {
    await car.updateVehicleState();
    print("Vehicle State:");
    if (raw) {
      print("\n  raw: "
          "${car.vehicleState.toJson().toString().replaceAll(", ", "\n    ")}");
    }
    print("${car.vehicleState}");
  }
}
