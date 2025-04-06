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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB2e0cWqgMskCyeykiWL0uK5ulc8_EutJQ',
    appId: '1:789618362953:web:5fa8289103e18f68fa0d98',
    messagingSenderId: '789618362953',
    projectId: 'taskify-3cd41',
    authDomain: 'taskify-3cd41.firebaseapp.com',
    storageBucket: 'taskify-3cd41.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPZK63jKfmHVe48H25Rr4-UNe24b_8Je4',
    appId: '1:789618362953:android:d4b9e8bf0f824062fa0d98',
    messagingSenderId: '789618362953',
    projectId: 'taskify-3cd41',
    storageBucket: 'taskify-3cd41.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8exLuR3mm9GYsb9Rj_Ypu5q3CR7FNP10',
    appId: '1:789618362953:ios:e75033b4ddbf7c8ffa0d98',
    messagingSenderId: '789618362953',
    projectId: 'taskify-3cd41',
    storageBucket: 'taskify-3cd41.firebasestorage.app',
    iosBundleId: 'com.example.taskify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2e0cWqgMskCyeykiWL0uK5ulc8_EutJQ',
    appId: '1:789618362953:web:5dfe331b6349c072fa0d98',
    messagingSenderId: '789618362953',
    projectId: 'taskify-3cd41',
    authDomain: 'taskify-3cd41.firebaseapp.com',
    storageBucket: 'taskify-3cd41.firebasestorage.app',
  );
}
