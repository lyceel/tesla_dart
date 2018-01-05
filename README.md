# tesla_dart
Dart libraries for accessing the Tesla API

Currently this documentation is targeted toward usage from a Linux machine,
but there shouldn't be anything preventing it from working on Windows or MacOS.

# Configuring Credentials #
Authentication with the Tesla API is performed using 
[OAuth2](https://oauth.net/2/).  The tesla.dart application uses the OAuth2
access and refresh tokens provided by the authentication API to access the
main API features.

In order to generate OAuth2 tokens required by the Tesla API, you must use
generate_token.dart. Create a file called .config containing your tesla.com
username on the first line, and password on the second line (make sure the
file isn't readable by anyone you don't trust!)  Next run generate_token.dart:

```shell
# pub run generate_token.dart
```

# Usage #
Without any parameters, the default behavior is to show you your vehicle's
state of charge.

The following arguments are available:

  --show-options   Show vehicle options and features
  --show-charge    Show state of charge (default)
  --show-climate   Show climate control settings
  --show-drive     Show drive information
  --show-gui       Show GUI settings
  --show-vehicle   Show vehicle state
  --show-all       Show all of the above

  --raw            Show raw data returned from server

