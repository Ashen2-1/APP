import 'dart:io';
import 'package:dart_ping/dart_ping.dart';

Future<bool> connectedToInternet() async {
  try {
    return true;
    // Future<bool> res = Ping("https://google.com").stream.isEmpty;

    // return !(await res);

    // final result = await InternetAddress.lookup("google.com");
    // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //   return true;
    // } else {
    //   return false;
    // }
  } on SocketException catch (_) {
    return false;
  }
}
