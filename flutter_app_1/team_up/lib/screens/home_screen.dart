import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:team_up/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
///////////////////首页的东西
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: (){
            FirebaseAuth.instance.signOut().then((value){
              print("Signed Out");
              Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });



            
          },
        ),
    
      ),
    );
  }
}