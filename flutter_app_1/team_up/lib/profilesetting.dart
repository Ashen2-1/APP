
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Creat Team Work Space"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          
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
                        
                        Text("TeamUp is a App"),

                        
                        
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