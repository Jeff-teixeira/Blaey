import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // Adicione outras plataformas conforme necessário
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCNTRnon4p9Ly4Y7xVz3TPgIjEoMuHaQgc',
    appId: '1:513721203811:web:f00cc47d451c5de2f20c56',
    messagingSenderId: '513721203811',
    projectId: 'blaeysuperapp',
    authDomain: 'blaeysuperapp.firebaseapp.com',
    storageBucket: 'blaeysuperapp.firebasestorage.app',
    measurementId: 'G-JKJ1GSZTCR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCNTRnon4p9Ly4Y7xVz3TPgIjEoMuHaQgc',
    appId: '1:513721203811:android:51cf6ef6c5701a6af20c56',
    messagingSenderId: '513721203811',
    projectId: 'blaeysuperapp',
    storageBucket: 'blaeysuperapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNTRnon4p9Ly4Y7xVz3TPgIjEoMuHaQgc',
    appId: '1:513721203811:ios:63af3e4f4a960529f20c56',
    messagingSenderId: '513721203811',
    projectId: 'blaeysuperapp',
    storageBucket: 'blaeysuperapp.firebasestorage.app',
    iosClientId: 'YOUR_IOS_CLIENT_ID_HERE',
    iosBundleId: 'com.example.blaey',
  );
}
