//@JS()
import 'dart:io';

// This is not used for now, but we might need it later
// import 'package:js/js.dart';

// @JS()
// class LacunaSignerWidget {
//   external factory LacunaSignerWidget();
//   external LacunaSignerWidget render(String embedUrl, String selector);
// }

// This class should NOT be used in production, it overrides self-signed
// certificates with an untrusted one, which could compromise security in
// a deployed app
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
