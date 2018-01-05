import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';

import 'package:tesla_dart/src/api_fetcher.dart';
import 'package:tesla_dart/src/auth.dart';
import 'package:tesla_dart/vehicle.dart';

Future main(List<String> args) async {
  var argParser = new ArgParser()
    ..addFlag('raw', defaultsTo: false)
    ..addFlag('show-options', defaultsTo: false)
    ..addFlag('show-charge', defaultsTo: true)
    ..addFlag('show-climate', defaultsTo: false)
    ..addFlag('show-drive', defaultsTo: false)
    ..addFlag('show-gui', defaultsTo: false)
    ..addFlag('show-vehicle', defaultsTo: false)
    ..addFlag('show-all', defaultsTo: false)
    ..addOption('access-token', abbr: 'a');

  var results = argParser.parse(args);
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
    print("${car.chargeState}");
    if (raw) {
      print("\n  raw: "
          "${car.chargeState.toJson().toString().replaceAll(", ", "\n    ")}");
    }
  }

  if (showClimate) {
    await car.updateClimateState();
    print("${car.climateState}");
    if (raw) {
      print("raw: "
          "${car.climateState.toJson().toString().replaceAll(", ", "\n    ")}");
    }
  }

  if (showDrive) {
    await car.updateDriveState();
    print("Drive State:");
    print("${car.driveState}");
  }

  if (showGui) {
    await car.updateGuiSettings();
    print("${car.guiSettings}");
  }

  if (showVehicle) {
    await car.updateVehicleState();
    print("${car.vehicleState}");
  }
}
