import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Activates attestation only on platforms with a production provider.
///
/// App Check must be registered in the Firebase Console before enforcement is
/// enabled. Windows deliberately remains unsupported here: the Flutter plugin
/// currently exposes only a debug provider on that platform, which must never
/// be used in a production build.
class AppCheckService {
  const AppCheckService._();

  static Future<void> activateForSupportedPlatforms() async {
    if (kIsWeb) {
      // Web needs a separately configured reCAPTCHA provider and site key.
      return;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        await FirebaseAppCheck.instance.activate(
          providerAndroid: const AndroidPlayIntegrityProvider(),
        );
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        await FirebaseAppCheck.instance.activate(
          providerApple: const AppleAppAttestWithDeviceCheckFallbackProvider(),
        );
        break;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return;
    }

    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  }
}
