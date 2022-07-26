import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import './lacuna_signer_widget.dart';

void main() {
  runApp(const MyApp());
}

Future<String> postEmbedUrl() async {
  // Perform POST Function
  HttpOverrides.global = MyHttpOverrides();
  // 10.0.2.2 is the default localhost for Android Emulator
  // if you wish to run on Flutter web, please refer to localhost as usual
  // For other platforms, please refer to: https://medium.com/@podcoder/connecting-flutter-application-to-localhost-a1022df63130
  var url = Uri.parse(
      'https://demos.lacunasoftware.com/api/signer/embedded?allowElectronic=true');
  var response = await http.post(url);
  print(response.body);
  return response.body;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signer Flutter Demo',
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
  late InAppWebViewController _controller;
  WebViewPage({
    Key? key,
    required this.url,
    required this.disableDocumentPreview,
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
                      'disableDocumentPreview': disableDocumentPreview
                    };
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
  int _counter = 0;
  bool _isPressed = false;
  late InAppWebViewController webViewController;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _sign(bool disableDocumentPreview) async {
    // disables button after click
    setState(() {
      _isPressed = true;
    });
    var embedUrl = await postEmbedUrl();
    renderWebView(embedUrl, disableDocumentPreview);
  }

  Future<void> renderWebView(String url, bool disableDocumentPreview) async {
    LocationPermission permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WebViewPage(
            url: url, disableDocumentPreview: disableDocumentPreview)));
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
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
              "Welcome to embedded signatures mobile sample!",
              textScaleFactor: 1.2,
            ),
            ElevatedButton(
              onPressed: () => _isPressed == false ? _sign(false) : null,
              child: const Text("Sign document"),
            ),
            ElevatedButton(
              onPressed: () => _isPressed == false ? _sign(true) : null,
              child: const Text("Sign document without preview"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
