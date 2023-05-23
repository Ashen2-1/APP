import 'package:flutter/material.dart';
import 'package:team_up/services/database_access.dart';
import 'package:team_up/widgets/reusable_widgets/reusable_widget.dart';
import 'package:team_up/constants/colors.dart';
import 'package:team_up/widgets/widgets.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({super.key});

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  int _time = -1;
  TextEditingController _tasks_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        child: Column(
          children: [
            Text("Available time: "),
            ListTile(
              title: const Text('10 mins'),
              leading: Radio<int>(
                value: 10,
                groupValue: _time,
                onChanged: (int? value) {
                  setState(() {
                    _time = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('20 mins'),
              leading: Radio<int>(
                value: 20,
                groupValue: _time,
                onChanged: (int? value) {
                  setState(() {
                    _time = value!;
                  });
                },
              ),
            ),
            reusableButton("Search for tasks", context, () async {
              _tasks_controller.text = await DatabaseAccess.getInstance()
                  .queryEqual("Programming (example)", "estimated time",
                      "${_time.toString()} mins") as String;
            }),
            reusableTextFieldRegular("", _tasks_controller, true),
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
