import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/profilesetting.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';

void main() async {
  runApp( ProfilePage());
}

class ProfilePage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ProfilePage",
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: (){},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.of(context)..push<void>(MaterialPageRoute<void>(builder: (BuildContext context) => const Profilesettingpage(),),);
            }, 
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left:16, top:25,right:16),
        child: GestureDetector(
          onTap:(){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500
              ),
              ),
              SizedBox(height: 15,),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0,10)
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          
                          image: NetworkImage("https://cdn-icons-png.flaticon.com/512/354/354637.png")
                        )
                      ),
              
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                      
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).scaffoldBackgroundColor
                        ),
                        color: Colors.black
                      ),
                      child: Icon(Icons.edit,color: Colors.white,),
                    ))
                  ],
                ),
              ),

////////////////////////////////////////////////////////////////
              SizedBox(height: 35,),

              buildTextFiels("User Name","User",false),
              buildTextFiels("E-mail","@gmail.com",false), //"${StudentData.studentEmail}"
              buildTextFiels("Password","******",true),
              buildTextFiels("Description","Tell us some thing",false),
              SizedBox(height: 15,),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: OutlinedButton(
                      
                      onPressed: (){

                      },
                      
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                          fontSize: 14, 
                          letterSpacing: 3.5, 
                          color: Colors.red
                          ),
                        )
                    ),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      ///////////////save the date to the firebase
                      onPressed: (){

                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          fontSize: 14, 
                          letterSpacing: 8, 
                          
                          color: Colors.green
                          ),
                        )
                    ),
                    
                  ),
                ],
              )


            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFiels(String labelText,String placeholder,bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
                obscureText: isPasswordTextField ? showPassword: false,
                decoration: InputDecoration(
                  suffixIcon: isPasswordTextField ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  ): null,
                  contentPadding: EdgeInsets.only(
                    bottom: 3
                  ),
                  labelText: labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: placeholder,
                  
                  hintStyle: TextStyle(
                    
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: Colors.grey
                  )
                ),
              ),
    );
  }
}
