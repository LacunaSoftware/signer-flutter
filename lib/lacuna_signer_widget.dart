@JS()
library jquery;

import 'package:js/js.dart';

// new jQuery invokes JavaScript `new jQuery()`
@JS()
class LacunaSignerWidget {
  external factory LacunaSignerWidget();
  external LacunaSignerWidget render(String embedUrl, String selector);
}
