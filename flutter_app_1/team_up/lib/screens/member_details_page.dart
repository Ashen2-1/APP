import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../calendar.dart';
import '../constants/student_data.dart';

class DetailPage extends StatelessWidget {
  final int index;
  bool isSwitched = false;
  DetailPage(this.index);
  Future<bool> isAdmin = StudentData.isAdmin();
  final TextEditingController _mentorEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("(User Name) details page"),/////User Name here
      ),
      body: Container(
        padding: EdgeInsets.only(left:16,top:25,right: 16),
        child: ListView(
          children: [
            
            Image.asset("assets/images/Mentor2.png",height: 188,width: 188,),
            SizedBox(height: 28,),
            Row(
              children: [
                
                Text(
                  "User Name:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,color: Color.fromARGB(255, 109, 109, 109)
                  ),
                ),
                SizedBox(width: 8,),
                Text(
                  "Put User Name Here", ////////////user name here
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,color: Color.fromARGB(255, 109, 109, 109)
                  ),
                ),
                
              ],
            ),
            SizedBox(height: 5,),
            Divider(height: 15, thickness: 2,),
            SizedBox(height: 18,),
            
            Row(
              children: [
                
                Text(
                  "User Contact:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,color: Color.fromARGB(255, 109, 109, 109)
                  ),
                ),
                SizedBox(width: 8,),
                Text(
                  "Put User Gamil here", ////////////user Gmail here
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,color: Color.fromARGB(255, 109, 109, 109)
                  ),
                ),
                
              ],
            ),
////////////////////////////////////////////////////////////////////////////////
            SizedBox(height: 5,),
            Divider(height: 15, thickness: 2,),
            SizedBox(height: 18,),
            

            GestureDetector(
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Tags:"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        
                        Text("Here is what ever User entered for their descriptions!!! EX.(Mentor,Menber,Team Captain,Leaders)"), //Here is what ever User entered for their descriptions!!!

                        
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
                  Text("Tags",style: TextStyle(
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
            SizedBox(height: 18,),
            Divider(height: 15, thickness: 2,),
            SizedBox(height: 18,),
/////////////////////////////////////////////////////////////////////////////////////////////////////
///   
            Row(
              children: [
                
                Text(
                  "Higher Access",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,color: Colors.grey[600]
                  ),
                ),
                SizedBox(width: 150,),
                LiteRollingSwitch(
                  onTap: (){}, 
                  onDoubleTap: (){}, 
                  onSwipe: (){}, 
                  width: 88,
                  iconOff: Icons.close,
                  colorOn: Colors.greenAccent,
                  colorOff: Colors.redAccent,

                  value: false, 
                  onChanged: (bool position){

                    
                    print(position);
                    //isAdmin == position;
                    //print(isAdmin);
                  },
                ),
 
              ],
            ),
//////////////////////////////////////////////////////////////////////
            SizedBox(height: 18,),
            Divider(height: 15, thickness: 2,),
            SizedBox(height: 18,),

            GestureDetector(
              onTap: () { //Here only show user it's own Attendance!!!
                Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (BuildContext context) => const AttendanceScreen(),),);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Attendance",style: TextStyle(
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
////////////////////////////////////////////////////////////
            SizedBox(height: 18,),
            Divider(height: 15, thickness: 2,),
            SizedBox(height: 8,),

            ElevatedButton(
              //// on pressed remove this user from the team
              onPressed: (){

              }, 
              style: ElevatedButton.styleFrom(
                  primary: Colors.red, ),
              child: 
                
                Text("Remove",style: TextStyle(fontSize: 28,color: Colors.white),)
            ),
          ],

          
        ),
      ),
    );
  }
}