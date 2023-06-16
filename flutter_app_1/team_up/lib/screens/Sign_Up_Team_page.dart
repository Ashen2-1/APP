import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_up/screens/home_screen.dart';




import '../services/file_uploader.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/round-button2.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';

import '../widgets/widgets.dart';


class Signupteam_page extends StatefulWidget {
  const Signupteam_page({Key? key}) : super(key: key);

  @override
  _Signupteam_pageState createState() => _Signupteam_pageState();
}

class _Signupteam_pageState extends State<Signupteam_page>
    with TickerProviderStateMixin {
  TextEditingController _teamnumberTextController = TextEditingController();
  TextEditingController _teamnameTextController = TextEditingController();
  TextEditingController _passcodeTextController = TextEditingController();
      
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

        backgroundColor: Color.fromARGB(231, 178, 34, 230),
        title: const Text(
          "Sign Up for Your Team Channel!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

      ),
      backgroundColor: Color.fromARGB(255, 201, 141, 141),
      
      body: Container(
        
        child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Text("Team Channel!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text("    Note: Team Channel Will have the same functions as the public channel but it only serve for the team mabers!",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                
                ),
                const SizedBox(
                  height: 40,
                ),
                reusableTextField("Enter Team Number", Icons.person_outline, false,
                    _teamnumberTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Team Name", Icons.person_outline, false,
                    _teamnameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Pass Code", Icons.lock_clock_outlined,
                    true, _passcodeTextController),
                
                const SizedBox(
                  height: 20,
                ),

                reusableButton("Upload a file related to task", context, () async {
                  File result = (await FileUploader.pickFile())!;
                  setState(() {
                    file = result;
                    isPlaying = true;
                  });
                }),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: (){
                  
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen())); 
                    /// here we can Navigator to Team Channel!
                },child: Text("Sign Up"),),

              ],
      ),
    ),
    );
  }
}