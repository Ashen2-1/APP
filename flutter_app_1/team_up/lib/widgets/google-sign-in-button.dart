import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/google_sign_in_auth.dart';

class GoogleSignInButton {
  static OutlinedButton googleSignInButton(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
      onPressed: () async {
        User? user = await GoogleSignInAuth.signInWithGoogle(context: context);

        if (user != null) {
          ConfigUtils.goToScreen(HomeScreen(), context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/images/google_logo.png"),
              height: 35.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
