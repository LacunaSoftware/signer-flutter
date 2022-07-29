# signer-flutter

Embedded signature sample for mobile devices, it has been tested on an Android emulator (API 31).

To run the project, start debugging the `lib/main.dart` file, you will need an Android phone or Android emulator. To check which devices are available for flutter, run:

> `flutter devices`

Make sure you're running in a compatible device. Next, navigate to the project folder and install dependencies with:

> `flutter pub get`

And finally, run the project with:

> `flutter run`

**Important**: In `lib/main.dart` inside `postEmbedUrl()` function, you should switch the url to the endpoint used in your application for further testing. The code can be found as shown in the variable below. The URL should be used **ONLY FOR DEMONSTRATION** purposes:

> `var url = Uri.parse(
      'https://demos.lacunasoftware.com/api/signer/embeddeallowElectronic=true');`

When creating a real application replace the URL with one from your own backend server. The endpoint should be responsible for creating a document and/or retrieving the embedded URL for a specific signer - as explained in our [integration guide](https://docs.lacunasoftware.com/en-us/articles/signer/integration-guide.html).