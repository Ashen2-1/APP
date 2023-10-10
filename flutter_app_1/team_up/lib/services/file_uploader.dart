import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter_logs/flutter_logs.dart';

class FileUploader {
  static FileUploader? _instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  FileUploader._internal();

  static FileUploader getInstance() {
    _instance ??= FileUploader._internal();
    return _instance!;
  }

  Future<TaskSnapshot> addFileToFirebaseStorage(
      String fileName, Uint8List? data) async {
    String imageName = fileName; //.path.split('/').last;
    //FlutterLogs.logInfo("Firebase", "Add image", "file Name: $imageName");
    Reference storageLocation = storage.ref().child("student_files/$imageName");

    //return await storageLocation.putFile(file);
    return await storageLocation.putData(data!);
  }

  static Future<File?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      //setState(() {
      File file = File(result.files.single.path ?? "");
      //});
      return file;
    }
  }
}
