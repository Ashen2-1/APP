import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:team_up/services/firebase_access.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';

class GoogleSignInAuth {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAccess.getInstance().getFirebaseAuth();
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    FlutterLogs.logInfo(
        "Google Sign In", "account info", "$googleSignInAccount");

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          displayError(
              "This account exists, but credentials are incorrect. Please try again.",
              context);
        } else if (e.code == 'invalid-credential') {
          displayError(
              "The credentials entered are not valid. Try again.", context);
        }
      } catch (e) {
        displayError(
            "An error occurred while signing in with Google. Try again another time or report to developers.",
            context);
      }
    }
    FlutterLogs.logInfo("Google Sign In", "account info", "$user");
    return user;
  }
}
