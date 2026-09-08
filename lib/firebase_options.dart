import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyApWf64V00rUcATRXg7Y5OqLZqTVBwweBI',
    appId: '1:432908192189:web:3044d50d573ca50f50ead4',
    messagingSenderId: '432908192189',
    projectId: 'easy-shop-4794e',
    authDomain: 'easy-shop-4794e.firebaseapp.com',
    storageBucket: 'easy-shop-4794e.firebasestorage.app',
    measurementId: 'G-2WB6B1KVR1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBre7kk9ifufyfLjdAo_jpljJd8-ZUkH7k',
    appId: '1:432908192189:android:ea7d98f33cd4997850ead4',
    messagingSenderId: '432908192189',
    projectId: 'easy-shop-4794e',
    storageBucket: 'easy-shop-4794e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJDYoYErUwlGWwDpeEWunCRcuy2XyY2hY',
    appId: '1:432908192189:ios:d7a79c8459ad189950ead4',
    messagingSenderId: '432908192189',
    projectId: 'easy-shop-4794e',
    storageBucket: 'easy-shop-4794e.firebasestorage.app',
    iosClientId:
        '432908192189-1170076uo8tng6ig77872e0ih52d0716.apps.googleusercontent.com',
    iosBundleId: 'com.example.buyVerseApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJDYoYErUwlGWwDpeEWunCRcuy2XyY2hY',
    appId: '1:432908192189:ios:d7a79c8459ad189950ead4',
    messagingSenderId: '432908192189',
    projectId: 'easy-shop-4794e',
    storageBucket: 'easy-shop-4794e.firebasestorage.app',
    iosClientId:
        '432908192189-1170076uo8tng6ig77872e0ih52d0716.apps.googleusercontent.com',
    iosBundleId: 'com.example.buyVerseApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyApWf64V00rUcATRXg7Y5OqLZqTVBwweBI',
    appId: '1:432908192189:web:912e59b3857a491150ead4',
    messagingSenderId: '432908192189',
    projectId: 'easy-shop-4794e',
    authDomain: 'easy-shop-4794e.firebaseapp.com',
    storageBucket: 'easy-shop-4794e.firebasestorage.app',
    measurementId: 'G-ZWFDBS2F83',
  );
}
