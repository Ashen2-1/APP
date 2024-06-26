import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:team_up/screens/my_team_page.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/utils/util.dart';

import '../calendar.dart';
import '../constants/student_data.dart';
import '../services/internet_connection.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  bool isSwitched = false;
  Future<dynamic> isAdmin = DatabaseAccess.getInstance()
      .getField("student tasks", StudentData.viewingUserEmail, "isAdmin");
  final TextEditingController _mentorEmailController = TextEditingController();

  Future<bool?> viewMentor({String viewingUser = ""}) async {
    if (viewingUser != "") {
      return (await DatabaseAccess.getInstance().getField(
              "student tasks", StudentData.viewingUserEmail, "isAdmin")) ||
          (await DatabaseAccess.getInstance()
              .getField("student tasks", StudentData.studentEmail, "isOwner"));
    }
    return (await StudentData.isAdmin()) ||
        (await DatabaseAccess.getInstance()
            .getField("student tasks", StudentData.studentEmail, "isOwner"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${StudentData.viewingUserEmail} details page"), /////User Name here
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            FutureBuilder(
                future: viewMentor(viewingUser: StudentData.viewingUserEmail),
                builder: (context, isAdmin) {
                  if (!isAdmin.hasData) {
                    return Container();
                  } else if (isAdmin.data!) {
                    return Image.asset(
                      "assets/images/Mentor2.png",
                      height: 188,
                      width: 188,
                    );
                  } else {
                    return Image.asset(
                      "assets/images/Students2.png",
                      height: 188,
                      width: 188,
                    );
                  }
                }),
            SizedBox(
              height: 28,
            ),
//             Row(
//               children: [
//                 Text(
//                   "User Name:",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Color.fromARGB(255, 109, 109, 109)),
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 Text(
//                   "Put User Name Here", ////////////user name here
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Color.fromARGB(255, 109, 109, 109)),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Divider(
//               height: 15,
//               thickness: 2,
//             ),
//             SizedBox(
//               height: 18,
//             ),

//             Row(
//               children: [
//                 Text(
//                   "User Contact:",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Color.fromARGB(255, 109, 109, 109)),
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 Text(
//                   "Put User Gamil here", ////////////user Gmail here
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: Color.fromARGB(255, 109, 109, 109)),
//                 ),
//               ],
//             ),
// ////////////////////////////////////////////////////////////////////////////////
//             SizedBox(
//               height: 5,
//             ),
//             Divider(
//               height: 15,
//               thickness: 2,
//             ),
//             SizedBox(
//               height: 18,
//             ),

            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("See their description"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                              future: DatabaseAccess.getInstance().getField(
                                  "student tasks",
                                  StudentData.viewingUserEmail,
                                  "description"),
                              builder: (context, description) {
                                if (!description.hasData) {
                                  return Container();
                                } else {
                                  return Text(description.data);
                                }
                              },
                            ) //Here is what ever User entered for their descriptions!!!

                            //Text("Public Channel"),
                          ],
                        ),
                        actions: [
                          FloatingActionButton(
                            onPressed: () {
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
                  Text(
                    "See description",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[600],
                  )
                ],
              ),
            ),
/////////////////////////////////////////////////////////////////////////////////////////////////////
            ///
            FutureBuilder(
                future: viewMentor(),
                builder: (context, isAdmin) {
                  if (!isAdmin.hasData) {
                    return Container();
                  } else if (!isAdmin.data!) {
                    return const SizedBox(height: 0);
                  }
                  return FutureBuilder(
                      future: DatabaseAccess.getInstance().getField(
                          "student tasks",
                          StudentData.viewingUserEmail,
                          "isAdmin"),
                      builder: (context, userIsAdmin) {
                        if (!userIsAdmin.hasData) {
                          return Container();
                        } else {
                          isSwitched = userIsAdmin.data;
                          return Column(children: [
                            SizedBox(
                              height: 18,
                            ),
                            Divider(
                              height: 15,
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Row(children: [
                              Text(
                                "Mentor Access",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600]),
                              ),
                              SizedBox(
                                width: 150,
                              ),
                              LiteRollingSwitch(
                                onTap: () {},
                                onDoubleTap: () {},
                                onSwipe: () {},
                                width: 88,
                                iconOff: Icons.close,
                                colorOn: Colors.greenAccent,
                                colorOff: Colors.redAccent,
                                value: isSwitched,
                                onChanged: (bool position) async {
                                  print(position);
                                  if (!await connectedToInternet()) {
                                    setState(() {
                                      isSwitched = position;
                                    });
                                    displayError(
                                        "Please connect to the Internet. Your previous change hasn't taken effect.",
                                        context);
                                  } else {
                                    DatabaseAccess.getInstance().updateField(
                                        "student tasks",
                                        StudentData.viewingUserEmail,
                                        {'isAdmin': position});
                                    if (position) {
                                      await Util.addToLog(
                                          "${StudentData.studentEmail} got mentor/lead privileges");
                                    } else {
                                      await Util.addToLog(
                                          "${StudentData.studentEmail} got removed mentor/lead privileges");
                                    }
                                  }
                                  //isAdmin == position;
                                  //print(isAdmin);
                                },
                              )
                            ])
                          ]);
                        }
                      });
                }),
//////////////////////////////////////////////////////////////////////
            ///
            ///
/////////////////////////////////////////////////////////////////////////////////////////////////////
            ///
            FutureBuilder(
                future: DatabaseAccess.getInstance().getField(
                    "student tasks", StudentData.studentEmail, "isOwner"),
                builder: (context, isOwner) {
                  if (!isOwner.hasData) {
                    return Container();
                  } else if (!isOwner.data!) {
                    return const SizedBox(height: 0);
                  }
                  return FutureBuilder(
                      future: DatabaseAccess.getInstance().getField(
                          "student tasks",
                          StudentData.viewingUserEmail,
                          "isOwner"),
                      builder: (context, userIsAdmin) {
                        if (!userIsAdmin.hasData) {
                          return Container();
                        } else {
                          isSwitched = userIsAdmin.data;
                          return Column(children: [
                            SizedBox(
                              height: 18,
                            ),
                            Divider(
                              height: 15,
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Row(children: [
                              Text(
                                "Owner Access",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600]),
                              ),
                              SizedBox(
                                width: 150,
                              ),
                              LiteRollingSwitch(
                                onTap: () {},
                                onDoubleTap: () {},
                                onSwipe: () {},
                                width: 88,
                                iconOff: Icons.close,
                                colorOn: Colors.greenAccent,
                                colorOff: Colors.redAccent,
                                value: isSwitched,
                                onChanged: (bool position) async {
                                  print(position);
                                  if (!await connectedToInternet()) {
                                    setState(() {
                                      isSwitched = position;
                                    });
                                    displayError(
                                        "Please connect to the Internet. Your previous change hasn't taken effect.",
                                        context);
                                  } else {
                                    DatabaseAccess.getInstance().updateField(
                                        "student tasks",
                                        StudentData.viewingUserEmail,
                                        {'isOwner': position});
                                    if (position) {
                                      await Util.addToLog(
                                          "${StudentData.studentEmail} got owner privileges");
                                    } else {
                                      await Util.addToLog(
                                          "${StudentData.studentEmail} got removed owner privileges");
                                    }
                                  }
                                  //isAdmin == position;
                                  //print(isAdmin);
                                },
                              )
                            ])
                          ]);
                        }
                      });
                }),
//////////////////////////////////////////////////////////////////////
            ///
            ///
            SizedBox(
              height: 18,
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 18,
            ),

            GestureDetector(
              onTap: () {
                //Here only show user it's own Attendance!!!
                StudentData.viewingOwnAttendance = true;
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const AttendanceScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Personal Attendance",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[600],
                  )
                ],
              ),
            ),
////////////////////////////////////////////////////////////
            SizedBox(
              height: 18,
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 8,
            ),

            FutureBuilder(
              future: DatabaseAccess.getInstance().getField(
                  "student tasks", StudentData.studentEmail, "isOwner"),
              builder: (context, isOwner) {
                if (!isOwner.hasData) {
                  return Container();
                } else if (isOwner.data!) {
                  return ElevatedButton(
                      //// on pressed remove this user from the team
                      onPressed: () async {
                        if (!(await connectedToInternet())) {
                          displayError(
                              "Please connect to the internet and try again",
                              context);
                        } else {
                          DatabaseAccess.getInstance().updateField(
                              "student tasks",
                              StudentData.viewingUserEmail,
                              {"team number": "", "normal team": ""});
                          ConfigUtils.goToScreen(const MyTeamPage(), context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text(
                        "Remove",
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ));
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
