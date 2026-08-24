import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:city_of_wealth/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Web client ID (client_type: 3) from google-services.json — required on
  // Android so the plugin can request an idToken for Firebase Auth.
  static const _webClientId =
      '390785055286-s3ushsr836vj5i61uk3obtljgvm09i1o.apps.googleusercontent.com';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Must be called once after Firebase.initializeApp() on mobile platforms.
  Future<void> initializeGoogleSignIn() async {
    await GoogleSignIn.instance.initialize(
      serverClientId: _webClientId,
    );
  }

  // Auth State Changes stream
  late final Stream<User?> authStateChanges = _auth.authStateChanges();

  // Current User
  User? get currentUser => _auth.currentUser;

  // Sign in with Email & Password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with Email & Password
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
        return await _signInWithGoogleWindows();
      }

      debugPrint('[GoogleSignIn] Calling authenticate()...');
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();
      debugPrint('[GoogleSignIn] authenticate() returned: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;
      debugPrint('[GoogleSignIn] idToken present: ${googleAuth.idToken != null}');
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      debugPrint('[GoogleSignIn] Signing in to Firebase...');
      final result = await _auth.signInWithCredential(credential);
      debugPrint('[GoogleSignIn] Firebase sign-in success: ${result.user?.uid}');
      return result;
    } on GoogleSignInException catch (e) {
      debugPrint('[GoogleSignIn] GoogleSignInException: code=${e.code}, $e');
      // User cancelled the sign-in — treat as a no-op, not an error.
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    } catch (e, stack) {
      debugPrint('[GoogleSignIn] Unexpected error: $e');
      debugPrint('[GoogleSignIn] Stack: $stack');
      rethrow;
    }
  }

  /// Google Sign-In for Windows using the implicit OAuth flow.
  ///
  /// Uses the existing Web Client ID (same Firebase web app config).
  /// Google returns id_token + access_token directly in the URL fragment,
  /// so no client_secret or token-exchange POST is needed.
  Future<UserCredential?> _signInWithGoogleWindows() async {
    HttpServer? server;
    int port = 8080;
    try {
      // Bind loopback server specifically on port 8080 (must match Google Cloud Console OAuth 2.0 authorized redirect URIs)
      try {
        server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
        port = 8080;
      } catch (_) {
        try {
          server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8000);
          port = 8000;
        } catch (_) {
          server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
          port = server.port;
        }
      }

      final redirectUri = 'http://localhost:$port/';

      // Web Client ID from google-services.json (client_type: 3)
      const clientId = _webClientId;

      final nonce = _generateRandomString(16);
      final state = _generateRandomString(16);

      // Implicit flow: response_type=token id_token returns tokens directly
      final authUrl = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'response_type': 'token id_token',
        'scope': 'openid email profile',
        'nonce': nonce,
        'state': state,
      });

      if (await canLaunchUrl(authUrl)) {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(authUrl);
      }

      // Listen for two requests:
      // 1. Google's redirect with tokens in the URL fragment (#)
      //    — we serve an HTML page that reads the fragment and sends tokens back
      // 2. Our JavaScript's fetch() call with tokens as query parameters
      final tokenCompleter = Completer<Map<String, String>>();

      server.listen((request) async {
        if (request.uri.path == '/auth-tokens') {
          // Second request: JavaScript sent us the tokens as query params
          final idToken = request.uri.queryParameters['id_token'];
          final accessToken = request.uri.queryParameters['access_token'];

          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..write('''
<!DOCTYPE html>
<html>
  <head>
    <title>City of Wealth - Authentication</title>
    <style>
      body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; text-align: center; padding: 50px; background-color: #121212; color: #ffffff; }
      .card { background: #1e1e1e; padding: 40px; border-radius: 12px; display: inline-block; box-shadow: 0 4px 12px rgba(0,0,0,0.5); }
      h1 { color: #4caf50; font-size: 24px; }
      p { color: #b0bec5; font-size: 16px; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>Authentication Successful!</h1>
      <p>You can close this tab and return to <strong>City of Wealth</strong>.</p>
    </div>
    <script>setTimeout(function() { window.close(); }, 2000);</script>
  </body>
</html>
''');
          await request.response.close();

          if (!tokenCompleter.isCompleted) {
            tokenCompleter.complete({
              'id_token': idToken ?? '',
              'access_token': accessToken ?? '',
            });
          }
        } else {
          // First request: Google redirected here with tokens in the URL fragment.
          // Fragments (#) are never sent to the server, so we serve a small HTML
          // page that reads the fragment and forwards tokens via fetch().
          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..write('''
<!DOCTYPE html>
<html>
  <head><title>Signing in…</title></head>
  <body>
    <p>Completing sign-in…</p>
    <script>
      var params = new URLSearchParams(window.location.hash.substring(1));
      var idToken = params.get('id_token') || '';
      var accessToken = params.get('access_token') || '';
      window.location.href = '/auth-tokens?id_token=' + encodeURIComponent(idToken) + '&access_token=' + encodeURIComponent(accessToken);
    </script>
  </body>
</html>
''');
          await request.response.close();
        }
      });

      final tokens = await tokenCompleter.future.timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          throw Exception("Google Sign-In timed out. Please try again.");
        },
      );

      await server.close();
      server = null;

      final idToken = tokens['id_token'];
      final accessToken = tokens['access_token'];

      if ((idToken == null || idToken.isEmpty) &&
          (accessToken == null || accessToken.isEmpty)) {
        throw Exception(
          "Google Sign-In failed: no tokens received. "
          "Make sure http://localhost:$port is added to Authorized JavaScript origins "
          "for your Web Client ID in Google Cloud Console.",
        );
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken?.isNotEmpty == true ? accessToken : null,
        idToken: idToken?.isNotEmpty == true ? idToken : null,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      await server?.close();
      rethrow;
    }
  }

  String _generateRandomString(int length) {
    final rand = Random.secure();
    final values = List<int>.generate(length, (_) => rand.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)) {
        await GoogleSignIn.instance.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      // Handle or ignore sign out errors
      await _auth.signOut();
    }
  }

  // Change Password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception("No authenticated user found.");
    }
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  // Delete Account & Clean Up Data
  // auth_service.dart
  Future<void> deleteAccount(String uid) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await FirestoreService().deleteUserData(uid); // clean up first
    await user.delete(); // then remove the login
  }
}

