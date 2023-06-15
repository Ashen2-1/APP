import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/screens/Feedback_page.dart';
import 'package:flutter_app_1/screens/home_screen.dart';
import 'package:flutter_app_1/screens/welcome_screen.dart';

import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';


class Approve_page extends StatefulWidget {
  const Approve_page({Key? key}) : super(key: key);

  @override
  _Approve_pageState createState() => _Approve_pageState();
}

class _Approve_pageState extends State<Approve_page>
    with TickerProviderStateMixin {
      
  late AnimationController controller;
  
  bool isPlaying = false;
  File? file;
  

  

  

  @override
  

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5fbff),
      body: Column(
        children: [
          
          
          SizedBox(height: 500,width: 20,),



          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 88),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               


                
                //SizedBox(height: 10,),
                GestureDetector(
                  
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Feedback_page()));
                    },
                    
                  child: RoundButton(
                    
                    icon: Icons.close, 
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: RoundButton(
                    icon: Icons.check,
                  ),
                ),
                
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
