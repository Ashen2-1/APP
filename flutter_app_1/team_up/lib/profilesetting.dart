
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:team_up/screens/Sign_Up_Team_page.dart';
import 'package:team_up/widgets/nav_bar.dart';

class Profilesettingpage extends StatefulWidget {
  const Profilesettingpage({super.key});

  @override
  State<Profilesettingpage> createState() => _ProfilesettingpageState();
}

class _ProfilesettingpageState extends State<Profilesettingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
      ),

      bottomNavigationBar: buildNavBar(context, 3),

      body: Container(
        padding: EdgeInsets.only(left:16,top:25,right: 16),
        child: ListView(
          children: [
            Text("Settings",style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500
            ),),
            SizedBox(height: 40,),
            Row(
              children: [
                Icon(Icons.person,color: Colors.black,),
                SizedBox(width: 10,),
                Text("Account",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
              ],
            ),




            Divider(height: 15, thickness: 2,),
            SizedBox(height: 18,),
/////////////////////////////////////
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Current Team"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        
                        //Text("Team#1360"),

                        TextButton(
                          onPressed: (){}, 
                          child: Text(
                            "Team#1360",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                            ),
                            )
                        ),


                        TextButton(
                          onPressed: (){}, 
                          child: Text(
                            "Public Channel",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                            ),
                            )
                        ),
                        
                        //Text("Public Channel"),
                      ],),
                      actions: [
                        FloatingActionButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                            },
                            child: Text("Close"),
                          )
                      ],
                    );
                  });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Current Team",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]
                  ),),
                  Icon(Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  )
                ],
              ),
            ),

/////////////////////////////////////////////////////
///
          SizedBox(height: 18,),
          GestureDetector(
//////////////////////////////////////////// chang to sign up for your team page
              onTap: () {
                Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (BuildContext context) => const Signupteam_page(),),);
              },
/////////////////////////////////////////////////////////


              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Creat Team Work Space",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]
                  ),),
                  Icon(Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  )
                ],
              ),
            ),
///////////////////////////////////////////////////////////
///
          SizedBox(height: 18,),
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("About TeamUp"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        
                        Text("TeamUp: Streamline collaboration effortlessly with our user-friendly app. Simplify task assignment, track progress, and facilitate seamless communication. Enhance productivity through intuitive features like shared calendars, real-time file sharing, and performance analytics. From project inception to completion, TeamUp empowers you to coordinate tasks, allocate resources, and celebrate milestones together. Experience the future of team management – efficient, cohesive, and rewarding. Join us in shaping a new era of teamwork. "),

                        SizedBox(height: 18,),
                        Text(
                          "Developers:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                        
                        //Text("Public Channel"),
                      ],),
                      actions: [
                        FloatingActionButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                            },
                            child: Text("Close"),
                          )
                      ],
                    );
                  });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("About TeamUp",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]
                  ),),
                  Icon(Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  )
                ],
              ),
            ),

/////////////////////////////////////////////////////
///
          SizedBox(height: 18,),
          Divider(height: 15, thickness: 2,),
          ],
        ),
      ),
    );
  }
}