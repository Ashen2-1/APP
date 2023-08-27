import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class DetailPage extends StatelessWidget {
  final int index;

  DetailPage(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("The details page"),
      ),
      body: Center(
        child: Text(
          "The details page of menber #$index", 
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}