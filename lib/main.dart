import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

List<DropdownMenuItem<String>> lacunaThemeItems = [
  const DropdownMenuItem(value: "", child: Text("Default theme")),
  const DropdownMenuItem(value: "apb", child: Text("Amaranth Pacific Blue")),
  const DropdownMenuItem(value: "acr", child: Text("Amazon Cornell Red")),
  const DropdownMenuItem(value: "azg", child: Text("Azure Lime Green")),
  const DropdownMenuItem(value: "cgo", child: Text("Castleton Green Orange")),
  const DropdownMenuItem(value: "clg", child: Text("Cerulean Lime Green")),
  const DropdownMenuItem(value: "cam", child: Text("Charcoal Amazonite")),
  const DropdownMenuItem(value: "clc", child: Text("Cobalt Lemon Curry")),
  const DropdownMenuItem(value: "dcg", child: Text("Dark Cerulean Green")),
  const DropdownMenuItem(value: "dgy", child: Text("Dark Grey Yellow")),
  const DropdownMenuItem(value: "dir", child: Text("Dark Indigo Red")),
  const DropdownMenuItem(
      value: "eva", child: Text("English Vermillion Arsenic")),
  const DropdownMenuItem(value: "gdc", child: Text("Green Dark Coral")),
  const DropdownMenuItem(value: "idg", child: Text("Independence Green")),
  const DropdownMenuItem(value: "mse", child: Text("Metallic Seaweed Emerald")),
  const DropdownMenuItem(value: "osg", child: Text("Onyx Satin Gold")),
  const DropdownMenuItem(value: "obg", child: Text("Oxford Blue Green")),
  const DropdownMenuItem(value: "pps", child: Text("Persian Plum Sand")),
  const DropdownMenuItem(value: "qbm", child: Text("Queen Blue Mint")),
  const DropdownMenuItem(value: "tbg", child: Text("Teal Blue Gold")),
  const DropdownMenuItem(value: "vgy", child: Text("Viridian Green Yellow")),
  const DropdownMenuItem(
      value: "iog", child: Text("International Orange Green")),
  const DropdownMenuItem(value: "oco", child: Text("Onyx Carrot Orange")),
  const DropdownMenuItem(
      value: "ioa", child: Text("International Orange Apricot")),
  const DropdownMenuItem(value: "gvb", child: Text("Generic Viridian Blue")),
  const DropdownMenuItem(value: "scy", child: Text("Space Cadet Yellow")),
  const DropdownMenuItem(value: "bvr", child: Text("Blue Venetian Red")),
  const DropdownMenuItem(value: "vsb", child: Text("Vivid Sky Blue")),
  const DropdownMenuItem(
      value: "ctv", child: Text("Chartreuse Traditional Violet")),
];

Future<String> postEmbedUrl() async {
  // IMPORTANT: This URL should be used ONLY FOR DEMONSTRATION purposes!!!!
  // When creating a real application replace the URL with one from
  // your own backend server. The endpoint should be responsible for creating a
  // document and/or retrieving the embedded URL for a specific signer -
  // as explained in our integration guide
  // (https://docs.lacunasoftware.com/en-us/articles/signer/integration-guide.html).
  var url = Uri.parse(
      'https://demos.lacunasoftware.com/api/signer/embedded?allowElectronic=true');

  // Perform POST Function
  var response = await http.post(url);
  return response.body;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Embedded Signer Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Embedded Signer Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController webViewController;
  String _themeVal = "";
  bool _isChecked = false;
  bool _buttonEnabled = true;

  //Function which shows Alert Dialog
  alertDialog(BuildContext context, String message) {
    // This is the ok button
    Widget ok = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          _buttonEnabled = true;
        });
      },
    );
    // show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error perfoming HTTP request!"),
          content: Text(
              "The request could not be completed, try again!\nErrorMessage:$message"),
          actions: [
            ok,
          ],
        );
      },
    );
  }

  void _sign(bool disableDocumentPreview) async {
    await postEmbedUrl()
        .then((embedUrl) => renderWebView(embedUrl, disableDocumentPreview))
        .catchError((err) => {alertDialog(context, err.toString())});
  }

  Future<void> renderWebView(String url, bool disableDocumentPreview) async {
    LocationPermission permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    bool result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WebViewPage(
            url: url,
            disableDocumentPreview: disableDocumentPreview,
            themeValue: _themeVal)));

    setState(() {
      _buttonEnabled = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Welcome to the embedded signatures mobile sample!",
            textScaleFactor: 1.0,
            style: TextStyle(fontSize: 16, height: 4.0),
          ),
          const Text("Select a theme for your widget:", textScaleFactor: 1.2),
          DropdownButton<String>(
            items: lacunaThemeItems,
            value: _themeVal,
            onChanged: (String? selectedItem) => setState(() {
              _themeVal = selectedItem!;
            }),
          ),
          CheckboxListTile(
            title: const Text("Disable preview of document"),
            value: _isChecked,
            onChanged: (bool? value) {
              // This is where we update the state when the checkbox is tapped
              setState(() {
                _isChecked = value!;
              });
            },
          ),
          ElevatedButton(
            onPressed: _buttonEnabled
                ? () async {
                    _sign(_isChecked);
                    setState(() {
                      _buttonEnabled = false;
                    });
                  }
                : null,
            child: const Text("Sign document"),
          ),
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;
  final bool disableDocumentPreview;
  String? themeValue;
  WebViewPage({
    Key? key,
    required this.url,
    required this.disableDocumentPreview,
    this.themeValue,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InAppWebView(
            initialFile: 'assets/signer_page.html',
            onWebViewCreated: (controller) {
              controller.addJavaScriptHandler(
                  handlerName: 'sign',
                  callback: (args) {
                    return {
                      'embedUrl': url,
                      'disableDocumentPreview': disableDocumentPreview,
                      'theme': themeValue
                    };
                  });
              controller.addJavaScriptHandler(
                  handlerName: 'unrenderView',
                  callback: (args) {
                    Navigator.pop(context, true);
                  });
            },
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(),
                android: AndroidInAppWebViewOptions(
//useHybridComposition: true
                    )),
            androidOnGeolocationPermissionsShowPrompt:
                (InAppWebViewController controller, String origin) async {
              bool result = await showDialog(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Allow access location $origin'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Text('Allow access location $origin'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Allow'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      TextButton(
                        child: const Text('Denied'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  );
                },
              );
              if (result) {
                return Future.value(GeolocationPermissionShowPromptResponse(
                    origin: origin, allow: true, retain: true));
              } else {
                return Future.value(GeolocationPermissionShowPromptResponse(
                    origin: origin, allow: false, retain: false));
              }
            },
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            }));
  }
}
