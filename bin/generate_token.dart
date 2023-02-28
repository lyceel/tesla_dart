import 'dart:async';
import 'dart:io';

import 'package:tesla/src/auth.dart';

Future<int> main() async {
  var creds;
  try {
    creds = (await File(".config").readAsString()).split('\n');
  } on IOException catch (e) {
    print("Credentials not found: $e");
    return 1;
  }
  if (creds == null || creds.length < 2) {
    print("Credentials invalid!");
    return 1;
  }
  var auth = await Auth.createFromCreds(creds[0], creds[1]);
  if (auth == null || auth.accessToken == null || auth.accessToken!.isEmpty) {
    print("Failed to authenticate!");
    return 1;
  }

  // Cache the token.
  await auth.writeToCache();

  return 0;
}
