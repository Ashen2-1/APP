import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';


class Signupteam_page extends StatefulWidget {
  const Signupteam_page({Key? key}) : super(key: key);

  @override
  _Signupteam_pageState createState() => _Signupteam_pageState();
}

class _Signupteam_pageState extends State<Signupteam_page>
    with TickerProviderStateMixin {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
      
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
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        title: const Text(
          "Sign Up for Your Team Channel!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

      ),

      
      body: Container(
        
        child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_clock_outlined,
                    true, _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
              ],
        ),
      );
    
  }
}