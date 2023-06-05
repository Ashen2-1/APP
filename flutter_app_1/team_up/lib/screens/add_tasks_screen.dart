import 'package:flutter/material.dart';
import 'package:team_up/screens/home_screen.dart';
import 'package:team_up/screens/page_navigation_screen.dart';
import 'package:team_up/screens/student_progress_screen.dart';
import 'package:team_up/utils/configuration_util.dart';

import '../constants/colors.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/widgets.dart';
import 'package:team_up/services/database_access.dart';

class AddTasksScreen extends StatefulWidget {
  const AddTasksScreen({Key? key}) : super(key: key);

  @override
  State<AddTasksScreen> createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends State<AddTasksScreen> {
  final TextEditingController _subTeamTextController = TextEditingController();
  final TextEditingController _taskTextController = TextEditingController();
  final TextEditingController _dueDateTextController = TextEditingController();
  final TextEditingController _skillsRequiredController =
      TextEditingController();
  final TextEditingController _estimatedTimeController =
      TextEditingController();

  final TextEditingController _submissionController = TextEditingController();

  bool _isExpanded = false;

  void menuToggleExpansion() {
    setState(() {
      ConfigUtils.goToScreen(PageNavigationScreen(), context);
      PageNavigationScreen.setIncomingScreen(AddTasksScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConfigUtils.configForBackButtonBehaviour(mainLayout, context);
  }

  Scaffold mainLayout() {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: buildAppBar(menuToggleExpansion),
      body: buildMainContent(),
    );
  }

  Widget buildMainContent() {
    List<TextEditingController> controllerList = [
      _subTeamTextController,
      _taskTextController,
      _dueDateTextController,
      _skillsRequiredController,
      _estimatedTimeController
    ];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(
                Icons.search,
                color: tdBlack,
                size: 20,
              ),
              prefixIconConstraints:
                  BoxConstraints(maxHeight: 20, minWidth: 25),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(color: tdGrey),
            ),
          ),
        ),
        reusableTextFieldRegular(
            "Enter Subteam", _subTeamTextController, false),
        reusableTextFieldRegular(
            "Enter Specific Task", _taskTextController, false),
        reusableTextFieldRegular(
            "Enter due date for task", _dueDateTextController, false),
        reusableTextFieldRegular(
            "Enter skills required for task", _skillsRequiredController, false),
        reusableTextFieldRegular(
            "Enter estimated time needed", _estimatedTimeController, false),
        reusableButton("ADD TO DATABASE", context, () {
          DatabaseAccess.getInstance()
              .addToDatabase("Tasks", _subTeamTextController.text, {
            "task": _taskTextController.text,
            "estimated time": _estimatedTimeController.text,
            "due date": _dueDateTextController.text,
            "skills needed": _skillsRequiredController.text
          });
          for (TextEditingController controller in controllerList) {
            controller.clear();
          }
          _submissionController.text = "Submitted!";
        }),
        reusableTextFieldRegular("", _submissionController, true),
      ],
    );
  }

  void goToProgress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => StudentProgressScreen()));
  }
}
