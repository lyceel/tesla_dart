import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'package:tesla/src/api_fetcher.dart';
import 'package:tesla/src/auth.dart';
import 'package:tesla/vehicle.dart';

bool raw = false;
bool dumpData = false;
bool showOptions = false;
bool showCharge = false;
bool showClimate = false;
bool showDrive = false;
bool showGui = false;
bool showVehicle = false;
bool showConfig = false;

Future main(List<String> args) async {
  var argParser = ArgParser()
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
        help: 'vehicle state (software version, name, doors, etc)')
    ..addFlag('show-config',
        abbr: 'C',
        defaultsTo: false,
        help: 'vehicle configuration (color, drivetrain, badging, etc)')
    ..addFlag('show-all', defaultsTo: false, help: 'shows all settings')
    ..addFlag('dump-data',
        defaultsTo: false,
        help: 'dumps all data about the vehicle (disables other output)')
    ..addFlag('help', abbr: 'h', help: 'prints this help')
    ..addOption('access-token', abbr: 'a')
    ..addMultiOption('car',
        help: 'index of the car to access; use "all" to print out each one',
        defaultsTo: ['0']);

  var results = argParser.parse(args);

  if (results.wasParsed('help')) {
    stderr.writeln("tesla.dart");
    for (var line in LineSplitter.split(argParser.usage)) {
      stderr.writeln("   $line");
    }
    await stderr.flush();
    return;
  }
  raw = results['raw'] ?? false;
  dumpData = results['dump-data'] ?? false;
  showOptions = results['show-options'] ?? false;
  showCharge = results['show-charge'] ?? false;
  showClimate = results['show-climate'] ?? false;
  showDrive = results['show-drive'] ?? false;
  showGui = results['show-gui'] ?? false;
  showVehicle = results['show-vehicle'] ?? false;
  showConfig = results['show-config'] ?? false;
  if (results['show-all']) {
    showOptions = true;
    showCharge = true;
    showClimate = true;
    showDrive = true;
    showGui = true;
    showVehicle = true;
    showConfig = true;
  }

  var fetcher = ApiFetcher(
      auth: results.wasParsed('access-token')
          ? Auth({'access_token': results['access-token']})
          : null);

  var vehicles = await Vehicle.getVehicles(fetcher);
  if (vehicles.length > 1 && !results.wasParsed('car')) {
    print('Cars detected:');
    int i = 0;
    for (var car in vehicles) {
      print('\t[${i++}] $car');
    }
    print('Use --car to select one, or "all"');
  }

  Iterable<String> resultCars = results['car'];
  List<Vehicle> selectedVehicles;
  if (resultCars.contains('all')) {
    selectedVehicles = vehicles;
  } else {
    selectedVehicles = [];
    for (String testIndex in resultCars) {
      int? index = int.tryParse(testIndex);
      if (index == null) {
        print('Error: --car expects an integer or "all". '
            'Seen: $testIndex');
        exit(1);
      }
      if (index < 0 || index >= vehicles.length) {
        print('Error: Invalid index; expected range [0..${vehicles.length}). '
            'Seen: $testIndex');
        exit(1);
      }
      selectedVehicles.add(vehicles[index]);
    }
  }
  for (var car in selectedVehicles) {
    await handleVehicle(car);
  }
}

Future<void> handleVehicle(Vehicle car) async {
  // If a data dump is requested, be sure to print nothing but that. This
  // makes it easier to capture.
  if (dumpData) {
    await car.wakeUp();
    await car.dumpData();
    return;
  }
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

  if (showConfig) {
    await car.updateVehicleConfig();
    print("Vehicle Config:");
    if (raw) {
      var json = car.vehicleConfig.toJson().toString();
      print("\n  raw: ${json.replaceAll(", ", "\n    ")}");
    }
    print("${car.vehicleConfig}");
  }
}
