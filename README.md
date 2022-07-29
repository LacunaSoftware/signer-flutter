# signer-flutter

Embedded signature sample for mobile devices, it has been tested on an Android emulator (API 31).

To run the project, start debugging the `lib/main.dart` file, you will need an Android phone or Android emulator. To check which devices are available for flutter, run:

> `flutter devices`

Make sure you're running in a compatible device. Next, navigate to the project folder and install dependencies with:

> `flutter pub get`

And finally, run the project with:

> `flutter run`

**Important**: In `lib/main.dart` inside `postEmbedUrl()` function, you should switch the url to the endpoint used in your application for further testing. The code can be found at line 53 as shown in the variable below:

> `var url = Uri.parse(
      'https://demos.lacunasoftware.com/api/signer/embeddeallowElectronic=true');`