import 'package:flutter/material.dart';

Container addToDatabaseButton(BuildContext context, Function onPressed) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onPressed();
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
