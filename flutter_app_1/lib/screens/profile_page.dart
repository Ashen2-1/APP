import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_1/main2.dart';

class ProfilePag extends StatefulWidget {
  const ProfilePag({super.key});

  @override
  State<ProfilePag> createState() => _ProfilePagState();
}

class _ProfilePagState extends State<ProfilePag> {

  //final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
         
        title: Text("                          Profile Page"),
        backgroundColor: Color(0xFF674AEF),
      ),
      
      body: ListView(
        children: [
          const SizedBox(height: 50),
          const Icon(
            Icons.person,
            size:72
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text("My Details",style: TextStyle(color: Colors.grey[600],),),
                      
          ),
          
        ],
      ),
    );
  }
}