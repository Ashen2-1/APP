import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/reusable_widgets/reusable_widget.dart';
import '../widgets/widgets.dart';
import 'package:team_up/services/database_access.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _subTeamTextController = TextEditingController();
  final TextEditingController _taskTextController = TextEditingController();
  final TextEditingController _dueDateTextController = TextEditingController();
  final TextEditingController _skillsRequiredController =
      TextEditingController();
  final TextEditingController _estimatedTimeController =
      TextEditingController();

  final TextEditingController _submissionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllerList = [
      _subTeamTextController,
      _taskTextController,
      _dueDateTextController,
      _skillsRequiredController,
      _estimatedTimeController
    ];

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
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
            reusableTextFieldRegular("Enter skills required for task",
                _skillsRequiredController, false),
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
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset("assets/images/avatar.jpeg"),
            ),
          ),
        ],
      ),
    );
  }
}
