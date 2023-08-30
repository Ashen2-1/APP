import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/screens/add_tasks_screen.dart';
import 'package:team_up/screens/student_tasks_screen.dart';
import 'package:team_up/widgets/nav_bar.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/student_progress_screen.dart';
import 'package:team_up/utils/configuration_util.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import '../constants/colors.dart';
import '../services/database_access.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List subNames = [
    "Programming",
    "Design",
    "Build",
    "Business",
    "Outreach",
    "Media",
  ];

  List<Color> optionColors = [
    //Color(0xFFFFCF2F),
    const Color(0xFF6FE08D),
    //Color(0xFF61BDFD),
    // Color(0xFFCB84FB),
    // Color(0xFF78E667),
  ];

  List<Icon> optionIcons = [
    //Icon(Icons.add_box_outlined, color: Colors.white, size: 30),
    //Icon(Icons.search, color: Colors.white, size: 30),
    const Icon(Icons.assignment_outlined, color: Colors.white, size: 30)
    // Icon(Icons.assessment, color: Colors.white, size: 30),
    // Icon(Icons.store, color: Colors.white, size: 30),
    // Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
    // Icon(Icons.emoji_events, color: Colors.white, size: 30),
  ];

  List textPageOptions = ['My Tasks'];
  static const List<Widget> pageOptions = [StudentTasksScreen()];

  List subteamList = [
    "Programming",
    "Design",
    "Build",
    "Media",
    "Business",
    "Outreach",
  ];

  List<int> numberTasks = [];

  Future<void> configureNumberTasks() async {
    FlutterLogs.logInfo("Home screen", "Configure number tasks", "in method");
    numberTasks.clear();
    for (String subteam in subteamList) {
      numberTasks.add(
          await DatabaseAccess.getInstance().getNumberOfSubteamTasks(subteam));
    }
    setState(() {});
  }

  void menuToggleExpansion() {
    setState(() {
      PageNavigationScreen.setIncomingScreen(const HomeScreen());
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
    });
  }

  @override
  void initState() {
    configureNumberTasks();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(() {
      return mainLayout(context);
    }, context);
  }

  Scaffold mainLayout(BuildContext context) {
    return Scaffold(
        //appBar: buildAppBar(menuToggleExpansion),
        bottomNavigationBar: buildNavBar(context, 0),
        body: buildMainContent(context));
  }

  Widget buildMainContent(BuildContext context) {
    return RefreshIndicator(
        onRefresh: configureNumberTasks,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 57, 189, 216),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Icon(
                  //       Icons.dashboard,
                  //       size: 30,
                  //       color: Colors.white,
                  //     ),
                  //     Icon(
                  //       Icons.notifications,
                  //       size: 30,
                  //       color: Colors.white,
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding:
                        EdgeInsets.only(left: 3, bottom: 15), //top bar size
                    child: Text(
                      "Hi, Engineer", // title size
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: StudentData.getStudentTeamNumber(),
                      builder: (context, studentTeamNumber) {
                        if (!studentTeamNumber.hasData) {
                          return Container();
                        }
                        return Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 55,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                Text("Team Number: ${studentTeamNumber.data}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                      wordSpacing: 2,
                                    )));
                      })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                children: [
                  GridView.builder(
                    itemCount: textPageOptions.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: optionColors[index], //subcolors
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: optionIcons[index],
                                ),
                              ),
                              onTap: () {
                                ConfigUtils.goToScreen(
                                    pageOptions[index], context);
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            //sub textsa colors
                            textPageOptions[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Search for Tasks",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF674AEF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                    itemCount: subteamList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          (MediaQuery.of(context).size.height - 50 - 25) /
                              (4 * 240),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          StudentData.setQuerySubTeam(subteamList[index]);
                          ConfigUtils.goToScreen(
                              const StudentProgressScreen(), context);
                        }, // Tap to each subteams
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFF5F3FF),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/images/${subteamList[index]}.png",
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                subteamList[index],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${numberTasks.isNotEmpty ? numberTasks[index] : 0} Tasks",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
