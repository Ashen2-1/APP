import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:team_up/screens/Approve_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Approve_page(),
    );
  }
  //Widget buildButtons(){
    //return ButtonWidget(
      //text: "Start Timer!"
      //onClicked: (){},
    //);
  //}
}