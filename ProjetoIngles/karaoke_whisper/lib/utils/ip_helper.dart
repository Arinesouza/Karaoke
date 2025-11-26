import 'dart:io';

class IpHelper {
  static Future<String> getLocalhostBaseUrl() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return "http://10.0.2.2:8000";
    }

    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 &&
              !addr.address.startsWith("127.")) {
            return "http://${addr.address}:8000";
          }
        }
      }
      return "http://127.0.0.1:8000";
    } catch (e) {
      return "http://127.0.0.1:8000";
    }
  }
}
