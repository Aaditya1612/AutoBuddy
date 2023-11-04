// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAsDgfp3ldEg72-PjK8-PblZm3SD1xBsCw',
    appId: '1:814057662169:web:e67ca7cd92da0d0c2500c8',
    messagingSenderId: '814057662169',
    projectId: 'autobuddy-d1489',
    authDomain: 'autobuddy-d1489.firebaseapp.com',
    storageBucket: 'autobuddy-d1489.appspot.com',
    measurementId: 'G-PGH2LN85MG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBgh_Ev_hp6abyL-gOXpiIKo7tKltiyMDo',
    appId: '1:814057662169:android:336423f930c745612500c8',
    messagingSenderId: '814057662169',
    projectId: 'autobuddy-d1489',
    storageBucket: 'autobuddy-d1489.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMg2YKSG3wJVv3XdqqhwR274hOzixpO2Q',
    appId: '1:814057662169:ios:590ed633b24fe45d2500c8',
    messagingSenderId: '814057662169',
    projectId: 'autobuddy-d1489',
    storageBucket: 'autobuddy-d1489.appspot.com',
    androidClientId: '814057662169-e6ao43firp6vkvgukkpun6bg39o1rvm0.apps.googleusercontent.com',
    iosClientId: '814057662169-oocnrug028fqu7oof4o9uk8i2cekr633.apps.googleusercontent.com',
    iosBundleId: 'com.example.autobuddy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMg2YKSG3wJVv3XdqqhwR274hOzixpO2Q',
    appId: '1:814057662169:ios:0764f1aefb5dee582500c8',
    messagingSenderId: '814057662169',
    projectId: 'autobuddy-d1489',
    storageBucket: 'autobuddy-d1489.appspot.com',
    androidClientId: '814057662169-e6ao43firp6vkvgukkpun6bg39o1rvm0.apps.googleusercontent.com',
    iosClientId: '814057662169-58mkete4p09882fr3cjns4n9l1dt97kc.apps.googleusercontent.com',
    iosBundleId: 'com.example.autobuddy.RunnerTests',
  );
}
