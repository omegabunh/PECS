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
    apiKey: 'AIzaSyCgJoIlfho8pDNXm1CV226_grkYvIlB3lI',
    appId: '1:1023385129878:web:c9a1470cd11798a1c383b7',
    messagingSenderId: '1023385129878',
    projectId: 'pubgtest-10121',
    authDomain: 'pubgtest-10121.firebaseapp.com',
    storageBucket: 'pubgtest-10121.appspot.com',
    measurementId: 'G-MKH8564W9K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFkS63HY-cYW6kakxUs8HEAMtlI-7r2Dc',
    appId: '1:1023385129878:android:e1b6775a4d8dd243c383b7',
    messagingSenderId: '1023385129878',
    projectId: 'pubgtest-10121',
    storageBucket: 'pubgtest-10121.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5DImaL2oSmEA-3THS8osxbvaQ9oJjklo',
    appId: '1:1023385129878:ios:93bbc0d08e860d7dc383b7',
    messagingSenderId: '1023385129878',
    projectId: 'pubgtest-10121',
    storageBucket: 'pubgtest-10121.appspot.com',
    iosClientId: '1023385129878-e95srsqt41qd7tp1r3sbnaq8ncvboa9p.apps.googleusercontent.com',
    iosBundleId: 'com.example.testPubg',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5DImaL2oSmEA-3THS8osxbvaQ9oJjklo',
    appId: '1:1023385129878:ios:93bbc0d08e860d7dc383b7',
    messagingSenderId: '1023385129878',
    projectId: 'pubgtest-10121',
    storageBucket: 'pubgtest-10121.appspot.com',
    iosClientId: '1023385129878-e95srsqt41qd7tp1r3sbnaq8ncvboa9p.apps.googleusercontent.com',
    iosBundleId: 'com.example.testPubg',
  );
}
