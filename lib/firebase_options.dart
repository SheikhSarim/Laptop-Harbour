// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCYIWvOMyNNLKpJqRED4IuWTZRM92MfZZw',
    appId: '1:1045514513525:web:a00ad77f534a1cfd021c3c',
    messagingSenderId: '1045514513525',
    projectId: 'laptop-harbour-b6832',
    authDomain: 'laptop-harbour-b6832.firebaseapp.com',
    storageBucket: 'laptop-harbour-b6832.firebasestorage.app',
    measurementId: 'G-FWMW00CH00',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKpEDbU7HL-G42-7Vm4iEvhf_OfgZEmrc',
    appId: '1:1045514513525:android:574dad0a8424154d021c3c',
    messagingSenderId: '1045514513525',
    projectId: 'laptop-harbour-b6832',
    storageBucket: 'laptop-harbour-b6832.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCRGjSPQZkEcDSX23kYJyCmW--VXbw2Hgo',
    appId: '1:1045514513525:ios:533a992cb7a20a24021c3c',
    messagingSenderId: '1045514513525',
    projectId: 'laptop-harbour-b6832',
    storageBucket: 'laptop-harbour-b6832.firebasestorage.app',
    iosBundleId: 'com.example.laptopsHarbour',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCRGjSPQZkEcDSX23kYJyCmW--VXbw2Hgo',
    appId: '1:1045514513525:ios:533a992cb7a20a24021c3c',
    messagingSenderId: '1045514513525',
    projectId: 'laptop-harbour-b6832',
    storageBucket: 'laptop-harbour-b6832.firebasestorage.app',
    iosBundleId: 'com.example.laptopsHarbour',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYIWvOMyNNLKpJqRED4IuWTZRM92MfZZw',
    appId: '1:1045514513525:web:a66ec8612be7c933021c3c',
    messagingSenderId: '1045514513525',
    projectId: 'laptop-harbour-b6832',
    authDomain: 'laptop-harbour-b6832.firebaseapp.com',
    storageBucket: 'laptop-harbour-b6832.firebasestorage.app',
    measurementId: 'G-BHPCJBTFWV',
  );
}
