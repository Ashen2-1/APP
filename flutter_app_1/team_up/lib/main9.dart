import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:team_up/screens/Enterteampasscode_page.dart';
import 'package:team_up/screens/Jointeam_page.dart';

import 'package:team_up/screens/Sign_Up_Team_page.dart';
import 'package:team_up/screens/TaskDescription_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: TaskDescription_page(),
    );
  }
  //Widget buildButtons(){
    //return ButtonWidget(
      //text: "Start Timer!"
      //onClicked: (){},
    //);
  //}
}