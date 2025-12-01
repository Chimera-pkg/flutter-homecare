import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Need to call this during app initialization
  Future<void> init() async {
    try {
      await _googleSignIn.initialize();
    } catch (e) {
      log("Error initializing Google Sign-In. Likely running on unsupported platform (Windows).",
          name: 'GoogleAuthSource');
    }
  }

  Future<String?> getGoogleIdToken() async {
    try {
      // Force sign in (popup)
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile', 'openid'],
      );

      final GoogleSignInAuthentication auth = account.authentication;
      return auth.idToken;
    } on GoogleSignInException catch (e, stackTrace) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // User cancelled the sign-in
        log("Google Sign-In cancelled by user.", name: 'GoogleAuthSource');
        return null;
      }
      log("Google Sign-In Error with code ${e.code}",
          error: e, stackTrace: stackTrace, name: 'GoogleAuthSource');
      rethrow;
    } catch (e, stackTrace) {
      log("Google SDK Error",
          error: e, stackTrace: stackTrace, name: 'GoogleAuthSource');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
