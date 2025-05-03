import 'dart:io' show Platform;

final String localhostUrl = () {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2';
  } else if (Platform.isIOS) {
    return 'http://localhost';
  } else {
    // Web or other platforms
    return 'http://localhost';
  }
}();

final String jLyricsBaseUrl = '$localhostUrl:3000';

final String voicevoxBaseUrl = '$localhostUrl:50021';