import 'package:flutter/material.dart';
import 'package:team_up/services/database_access.dart';

Container addToDatabaseButton(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        DatabaseAccess.getInstance().addToDatabase("tasks", "Assemble DT",
            const {"time": 20, "due date": "May 23, 2023"});
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: const Text(
        "ADD TO DATABASE",
        style: TextStyle(
            color: Color.fromARGB(221, 243, 181, 24),
            fontWeight: FontWeight.bold,
            fontSize: 16),
      ),
    ),
  );
}
