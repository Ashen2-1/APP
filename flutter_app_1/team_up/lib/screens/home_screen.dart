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
    Color(0xFFFFCF2F),
    Color(0xFF6FE08D),
    //Color(0xFF61BDFD),
    // Color(0xFFFC7F7F),
    // Color(0xFFCB84FB),
    // Color(0xFF78E667),
  ];

  List<Icon> optionIcons = [
    Icon(Icons.add_box_outlined, color: Colors.white, size: 30),
    //Icon(Icons.search, color: Colors.white, size: 30),
    Icon(Icons.assignment_outlined, color: Colors.white, size: 30)
    // Icon(Icons.assessment, color: Colors.white, size: 30),
    // Icon(Icons.store, color: Colors.white, size: 30),
    // Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
    // Icon(Icons.emoji_events, color: Colors.white, size: 30),
  ];

  List textPageOptions = ['Add a task!', 'My Tasks'];
  static const List<Widget> pageOptions = [
    AddTasksScreen(),
    StudentTasksScreen()
  ];

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
      PageNavigationScreen.setIncomingScreen(HomeScreen());
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
        appBar: buildAppBar(menuToggleExpansion),
        bottomNavigationBar: buildNavBar(context, 0),
        body: buildMainContent(context));
  }

  Widget buildMainContent(BuildContext context) {
    return RefreshIndicator(
        onRefresh: configureNumberTasks,
        child: ListView(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xFF674AEF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.dashboard,
                        size: 30,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.notifications,
                        size: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
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
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      //search bar
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here...",
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                children: [
                  GridView.builder(
                    itemCount: textPageOptions.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      Text(
                        "Search for Tasks",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF674AEF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                    itemCount: subteamList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                              StudentProgressScreen(), context);
                        }, // Tap to each subteams
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFF5F3FF),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/images/${subteamList[index]}.png",
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                subteamList[index],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(height: 10),
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
