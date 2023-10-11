import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:team_up/screens/add_tasks_screen.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/signin_screen.dart';
import 'package:team_up/screens/student_progress_screen.dart';
import 'package:team_up/services/PushNotificationService.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'dart:io';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

  // Your web app's Firebase configuration
  // For Firebase JS SDK v7.20.0 and later, measurementId is optional
  FirebaseOptions firebaseConfig = const FirebaseOptions(
      apiKey: "AIzaSyAX3IM9_GeuNXxPKQQ-6FpwWUwu3lWBjW4",
      authDomain: "team-up1-a6ad3.firebaseapp.com",
      projectId: "team-up1-a6ad3",
      storageBucket: "team-up1-a6ad3.appspot.com",
      messagingSenderId: "678384237313",
      appId: "1:678384237313:web:70fac6f7a8ea55093a7900",
      measurementId: "G-6R31VTL0G1");

  // Initialize Firebase

  await Firebase.initializeApp(options: firebaseConfig);

  //Initialize Logging
  // await //FlutterLogs.initLogs(
  //     logLevelsEnabled: [
  //       LogLevel.INFO,
  //       LogLevel.WARNING,
  //       LogLevel.ERROR,
  //       LogLevel.SEVERE
  //     ],
  //     timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
  //     directoryStructure: DirectoryStructure.FOR_DATE,
  //     logTypesEnabled: ["device", "network", "errors"],
  //     logFileExtension: LogFileExtension.LOG,
  //     logsWriteDirectoryName: "./MyLogs",
  //     logsExportDirectoryName: "MyLogs/Exported",
  //     debugFileOperations: trrue,
  //     isDebuggable: true);

  await PushNotificationService.initialize();

  setUrlStrategy(null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //if (Platform.isAndroid) {
    return MaterialApp(
      title: 'Team Up',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes toP "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: //const HomeScreen(),
          //const AddTasksScreen(), //StudentProgressScreen(), //const SignInScreen(),
          const SignInScreen(),
    );
    // } else if (Platform.isWindows) {
    //   return FluentUI.FluentApp(
    //     title: 'Team Up',
    //     // theme: ThemeData(
    //     //   // This is the theme of your application.
    //     //   //
    //     //   // Try running your application with "flutter run". You'll see the
    //     //   // application has a blue toolbar. Then, without quitting the app, try
    //     //   // changing the primarySwatch below to Colors.green and then invoke
    //     //   // "hot reload" (press "r" in the console where you ran "flutter run",
    //     //   // or simply save your changes toP "hot reload" in a Flutter IDE).
    //     //   // Notice that the counter didn't reset back to zero; the application
    //     //   // is not restarted.
    //     //   primarySwatch: Colors.blue,
    //     // ),
    //     home:
    //         //const AddTasksScreen(), //StudentProgressScreen(), //const SignInScreen(),
    //         const SignInScreen(),
    //   );
    // } else {
    //   return Container();
    // }
  }
}
