

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/widgets/widgets.dart';
import '../constants/colors.dart';
import '../utils/util.dart';

class Jointeam_page extends StatefulWidget {
  const Jointeam_page({Key? key}) : super(key: key);

  @override
  State<Jointeam_page> createState() => _Jointeam_pageState();
}

class _Jointeam_pageState extends State<Jointeam_page> {
  bool _isExpanded = false;

  List<Map<String, dynamic>>? studentTasksMap;
  //List<String> task = [];

  TextEditingController _teamnumberTextController = TextEditingController();
  

  

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(Jointeam_page());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(mainLayout, context);
  }

  Scaffold mainLayout() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 141, 141),
      appBar:  AppBar(

        backgroundColor: Color.fromARGB(231, 178, 34, 230),
        title: const Text(
          "          Join a Team Channel!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

      ),
      
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    return Column(
      
      children: [
        SizedBox(height: 20,),
        const Text("Available Teams: ",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        SizedBox(height: 20,),
        
        reusableTextFieldRegular(
            "Enter Specific Team Number", _teamnumberTextController, false),
        
         // to search their team by team number!
        
        //ListTile(
          //title: const Text('Team number:'),
          
        //),

        


        SizedBox(height: 469,),
        
        reusableButton("Update/Search The Teams", context, () async {
          //configure();
        }),
      ],
    );
  }
}
