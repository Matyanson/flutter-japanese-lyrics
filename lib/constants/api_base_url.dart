import 'dart:io' show Platform;

final String apiBaseUrl = () {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:3000';
  } else if (Platform.isIOS) {
    return 'http://localhost:3000';
  } else {
    // Web nebo jiné platformy
    return 'http://localhost:3000';
  }
}();