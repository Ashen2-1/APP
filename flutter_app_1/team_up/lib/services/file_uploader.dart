import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FileUploader {
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
