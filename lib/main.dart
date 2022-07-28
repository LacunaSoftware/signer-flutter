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
  DropdownMenuItem(child: Text("Default theme"), value: ""),
  DropdownMenuItem(child: Text("Amaranth Pacific Blue"), value: "apb"),
  DropdownMenuItem(child: Text("Amazon Cornell Red"), value: "acr"),
  DropdownMenuItem(child: Text("Azure Lime Green"), value: "azg"),
  DropdownMenuItem(child: Text("Castleton Green Orange"), value: "cgo"),
  DropdownMenuItem(child: Text("Cerulean Lime Green"), value: "clg"),
  DropdownMenuItem(child: Text("Charcoal Amazonite"), value: "cam"),
  DropdownMenuItem(child: Text("Cobalt Lemon Curry"), value: "clc"),
  DropdownMenuItem(child: Text("Dark Cerulean Green"), value: "dcg"),
  DropdownMenuItem(child: Text("Dark Grey Yellow"), value: "dgy"),
  DropdownMenuItem(child: Text("Dark Indigo Red"), value: "dir"),
  DropdownMenuItem(child: Text("English Vermillion Arsenic"), value: "eva"),
  DropdownMenuItem(child: Text("Green Dark Coral"), value: "gdc"),
  DropdownMenuItem(child: Text("Independence Green"), value: "idg"),
  DropdownMenuItem(child: Text("Metallic Seaweed Emerald"), value: "mse"),
  DropdownMenuItem(child: Text("Onyx Satin Gold"), value: "osg"),
  DropdownMenuItem(child: Text("Oxford Blue Green"), value: "obg"),
  DropdownMenuItem(child: Text("Persian Plum Sand"), value: "pps"),
  DropdownMenuItem(child: Text("Queen Blue Mint"), value: "qbm"),
  DropdownMenuItem(child: Text("Teal Blue Gold"), value: "tbg"),
  DropdownMenuItem(child: Text("Viridian Green Yellow"), value: "vgy"),
  DropdownMenuItem(child: Text("International Orange Green"), value: "iog"),
  DropdownMenuItem(child: Text("Onyx Carrot Orange"), value: "oco"),
  DropdownMenuItem(child: Text("International Orange Apricot"), value: "ioa"),
  DropdownMenuItem(child: Text("Generic Viridian Blue"), value: "gvb"),
  DropdownMenuItem(child: Text("Space Cadet Yellow"), value: "scy"),
  DropdownMenuItem(child: Text("Blue Venetian Red"), value: "bvr"),
  DropdownMenuItem(child: Text("Vivid Sky Blue"), value: "vsb"),
  DropdownMenuItem(child: Text("Chartreuse Traditional Violet"), value: "ctv"),
];

Future<String> postEmbedUrl() async {
  // Perform POST Function
  var url = Uri.parse(
      'https://demos.lacunasoftware.com/api/signer/embedded?allowElectronic=true');
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
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Signer Demo Home Page'),
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
                    Navigator.pop(context);
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
                        child: Text('Allow'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      TextButton(
                        child: Text('Denied'),
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

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController webViewController;
  String _themeVal = "";
  bool _isChecked = false;

  void _sign(bool disableDocumentPreview) async {
    var embedUrl = await postEmbedUrl();
    renderWebView(embedUrl, disableDocumentPreview);
  }

  Future<void> renderWebView(String url, bool disableDocumentPreview) async {
    LocationPermission permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WebViewPage(
            url: url,
            disableDocumentPreview: disableDocumentPreview,
            themeValue: _themeVal)));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
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
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
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
          const Text("Please select an option:", textScaleFactor: 1.2),
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
            onPressed: () => _sign(_isChecked),
            child: const Text("Sign document"),
          ),
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
