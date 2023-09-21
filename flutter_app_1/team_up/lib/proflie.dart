import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/profilesetting.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/services/internet_connection.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';

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

  TextEditingController username_controller = TextEditingController();
  //TextEditingController password_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        //   onPressed: (){},
        // ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context)
                ..push<void>(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const Profilesettingpage(),
                  ),
                );
            },
          ),
        ],
      ),
      bottomNavigationBar: buildNavBar(context, 3),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    FutureBuilder(
                        future: StudentData.isAdmin(),
                        builder: (context, isAdmin) {
                          if (!isAdmin.hasData) {
                            return Container();
                          }
                          return Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: isAdmin.data!
                                        ? Image.asset(
                                                'assets/images/Mentor2.png')
                                            .image
                                        : Image.asset(
                                                'assets/images/Students2.png')
                                            .image),
                              ));
                        })
                    // Edit icon
                    // Positioned(
                    //     bottom: 0,
                    //     right: 0,
                    //     child: Container(
                    //       height: 40,
                    //       width: 40,
                    //       decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           border: Border.all(
                    //               width: 4,
                    //               color: Theme.of(context)
                    //                   .scaffoldBackgroundColor),
                    //           color: Colors.black),
                    //       child: const Icon(
                    //         Icons.edit,
                    //         color: Colors.white,
                    //       ),
                    //     ))
                  ],
                ),
              ),

////////////////////////////////////////////////////////////////
              const SizedBox(
                height: 35,
              ),
              FutureBuilder(
                  future: DatabaseAccess.getInstance().getField(
                      "student tasks", StudentData.studentEmail, "username"),
                  builder: (context, username) {
                    if (!username.hasData) {
                      return Container();
                    }
                    username_controller.text = username.data;
                    return buildTextFiels(
                        "User Name", "User", false, username_controller);
                  }),
              // buildTextFiels("E-mail", "@gmail.com",
              //     false), //"${StudentData.studentEmail}"
              Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Text("Email: ${StudentData.studentEmail}",
                      style: const TextStyle(fontSize: 16))),
              //buildTextFiels("Password", "******", true, password_controller),
              FutureBuilder(
                  future: DatabaseAccess.getInstance().getField(
                      "student tasks", StudentData.studentEmail, "description"),
                  builder: (context, description) {
                    if (!description.hasData) {
                      return Container();
                    }
                    description_controller.text = description.data;
                    return buildTextFiels("Description", "Tell us some thing",
                        false, description_controller);
                  }),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: OutlinedButton(
                        onPressed: () {
                          ConfigUtils.goToScreen(const HomeScreen(), context);
                        },
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 3.5,
                              color: Colors.red),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                        ///////////////save the date to the firebase
                        onPressed: () async {
                          if (!(await connectedToInternet())) {
                            displayError(
                                "Please connect to the internet and try again",
                                context);
                          } else {
                            DatabaseAccess.getInstance().updateField(
                                "student tasks", StudentData.studentEmail, {
                              "username": username_controller.text,
                              "description": description_controller.text
                            });
                            ConfigUtils.goToScreen(const HomeScreen(), context);
                          }
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 8,
                              color: Colors.green),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFiels(String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        controller: controller,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
