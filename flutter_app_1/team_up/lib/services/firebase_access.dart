import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_logs/flutter_logs.dart';

class FirebaseAccess {
  static FirebaseAccess? _instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseAccess getInstance() {
    _instance ??= FirebaseAccess._internal();
    return _instance!;
  }

  FirebaseAccess._internal();

  String getUserEmail() {
    User? user = _auth.currentUser;
    FlutterLogs.logInfo(
        "Firebase Data", "User Email", "Current Email is: ${user!.email}");
    return user.email!;
  }
}
