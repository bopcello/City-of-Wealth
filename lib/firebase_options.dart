import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBieTycJvZxIzasz3-2AuiJuiU2Mj7UMJ4',
    appId: '1:390785055286:android:55fc0d8ad5273a8f563697',
    messagingSenderId: '390785055286',
    projectId: 'city-of-wealth',
    storageBucket: 'city-of-wealth.firebasestorage.app',
  );

  // iOS configuration is blank as requested.
  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'YOUR-IOS-API-KEY',
  //   appId: 'YOUR-IOS-APP-ID',
  //   messagingSenderId: 'YOUR-SENDER-ID',
  //   projectId: 'YOUR-PROJECT-ID',
  //   storageBucket: 'YOUR-STORAGE-BUCKET',
  //   iosBundleId: 'com.example.cityOfWealth',
  // );
}
