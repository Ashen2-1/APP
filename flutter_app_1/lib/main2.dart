import 'package:flutter/material.dart';
import 'package:flutter_app_1/file_uploader.dart';
import 'package:flutter_app_1/screens/home_screen.dart';
import 'package:flutter_app_1/screens/profile_page.dart';
import 'package:flutter_app_1/screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}