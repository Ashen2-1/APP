import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app_1/screens/Approve_page.dart';
import 'package:flutter_app_1/screens/Sign_Up_Team_page.dart';
import 'package:flutter_app_1/widgets/button_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Signupteam_page(),
    );
  }
  //Widget buildButtons(){
    //return ButtonWidget(
      //text: "Start Timer!"
      //onClicked: (){},
    //);
  //}
}