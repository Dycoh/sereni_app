// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCceSO79NbvuFnlDsPOF2Gh9RRs4LyIiVw',
    appId: '1:452402837422:web:fd11fb62c90d3e159f7a3f',
    messagingSenderId: '452402837422',
    projectId: 'sereni-backend',
    authDomain: 'sereni-backend.firebaseapp.com',
    storageBucket: 'sereni-backend.firebasestorage.app',
    measurementId: 'G-R0D0TKJQCK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjlsOlHlKoPhVQZCEZPKpO9dvSk07AxSE',
    appId: '1:452402837422:android:6e970826e44142e19f7a3f',
    messagingSenderId: '452402837422',
    projectId: 'sereni-backend',
    storageBucket: 'sereni-backend.firebasestorage.app',
  );
}