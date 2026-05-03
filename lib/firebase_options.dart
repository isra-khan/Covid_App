// File generated to match android/app/google-services.json and
// ios/Runner/GoogleService-Info.plist. If you re-run `flutterfire configure`,
// it will overwrite this file.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'run `flutterfire configure` to add web support.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'run `flutterfire configure` to add macOS support.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'run `flutterfire configure` to add Windows support.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'run `flutterfire configure` to add Linux support.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADjgVAGUjFvmemGt7T0fEIgykwXtRGk7Y',
    appId: '1:381833628392:android:64c430211a2d66ebf0175d',
    messagingSenderId: '381833628392',
    projectId: 'crypto-app-tps',
    databaseURL: 'https://crypto-app-tps-default-rtdb.firebaseio.com',
    storageBucket: 'crypto-app-tps.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3N_DoWj9Sr-x2PLeQ2rATIIEtF43k_7Y',
    appId: '1:381833628392:ios:1c7b0f016cca6486f0175d',
    messagingSenderId: '381833628392',
    projectId: 'crypto-app-tps',
    databaseURL: 'https://crypto-app-tps-default-rtdb.firebaseio.com',
    storageBucket: 'crypto-app-tps.firebasestorage.app',
    iosBundleId: 'com.example.covidapp',
  );
}
