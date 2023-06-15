import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
void main() {
  runApp(MyApp());
}

File file = File("");

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key:key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          
          children: [
            //Image(image:AssetImage("") )  //show image on the app
            Image.file(file),
            
            
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  
                ),
              ),
            ),


            TextButton(
              
              onPressed: (){
              pickFile();
            
            }, child: const Text("Pick File"),
              
            ),
                    
            
          ],
        ),
      ),
    );
  }
  
  
  void pickFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any
    );
    if(result!=null){
      setState(() {
        file = File(result.files.single.path ?? "");
      });
    }
  }
}



