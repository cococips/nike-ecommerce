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
        return ios;
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
    apiKey: 'AIzaSyCPaE20m2d_UnZkEUMYbUQQ2VAJ3UdCODU',
    appId: '1:80419558247:web:f11a46e887b9943b8c95c2',
    messagingSenderId: '80419558247',
    projectId: 'nike-store-app-fe8ff',
    authDomain: 'nike-store-app-fe8ff.firebaseapp.com',
    storageBucket: 'nike-store-app-fe8ff.appspot.com',
    measurementId: 'G-4N2NRVSQQC',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6InUmRDnbyh6vCjjQex_c2AVd5rkV-MQ',
    appId: '1:80419558247:ios:63acffb5753da7e38c95c2',
    messagingSenderId: '80419558247',
    projectId: 'nike-store-app-fe8ff',
    storageBucket: 'nike-store-app-fe8ff.appspot.com',
    iosBundleId: 'com.nike.nikeEcommerce',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYsr1mN5vJO_dvIbfHMCbFwPpYCi-KWGI',
    appId: '1:80419558247:android:e2d1870f2298fa958c95c2',
    messagingSenderId: '80419558247',
    projectId: 'nike-store-app-fe8ff',
    storageBucket: 'nike-store-app-fe8ff.appspot.com',
  );

}