import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';

import '../services/database_access.dart';
import 'package:image/image.dart' as IMG;

///
/// A class for storing utility static functions which may parse data, etc..

class Util {
  static bool isTaskIn(
      String taskName, List<Map<String, dynamic>>? taskListOfDict) {
    for (Map<String, dynamic> map in taskListOfDict!) {
      if (map['task'] == taskName) return true;
    }
    return false;
  }

  static bool contains(String item, List<String> list) {
    for (String element in list) {
      if (element == item) {
        return true;
      }
    }
    return false;
  }

  static Future<List<Map<String, dynamic>>> combineTaskIntoExisting(
      Map<String, dynamic> taskToAdd,
      List<Map<String, dynamic>>? prevTasks) async {
    FlutterLogs.logInfo("print prev tasks", " ", "$prevTasks");
    if (prevTasks == null || prevTasks.isEmpty)
      prevTasks = [taskToAdd];
    else {
      if (!Util.isTaskIn(
          taskToAdd['task'], prevTasks.cast<Map<String, dynamic>>())) {
        prevTasks.add(taskToAdd);
      }
    }

    return prevTasks;
  }

  static List<Map<String, dynamic>> matchAndCombineExisting(
      Map<String, dynamic> taskToAdd, List<Map<String, dynamic>>? prevTasks) {
    if (prevTasks == null || prevTasks.isEmpty)
      prevTasks = [taskToAdd];
    else {
      //for (Map<String, dynamic> taskMap in prevTasks) {
      for (int i = 0; i < prevTasks.length; i++) {
        if (prevTasks[i]['task'] == taskToAdd['task']) {
          prevTasks[i] = taskToAdd;
        }
      }
    }
    return prevTasks;
  }

  static List<String> getTimeInRange(String timeRange) {
    if (timeRange == "20 minutes or less") {
      return ['10 minutes', '20 minutes'];
    } else if (timeRange == "30 minutes - 40 minutes") {
      return ['30 minutes', '40 minutes'];
    } else if (timeRange == "1 hour - 2 hours") {
      return ['1 hour', '1 and 1/2 hour', '2 hours'];
    }
    return [];
  }

  static int convertStringTimeToIntMinutes(String time) {
    if (time.contains('minutes')) {
      return int.parse(time.substring(0, 2));
    } else if (time.contains('hour')) {
      time = time.replaceAll("s", "");
      time = time.replaceAll(" and 1/2 ", ".5");
      time = time.substring(0, time.length - 4);
      FlutterLogs.logInfo("parsing time", "calc", "string: $time");
      return (double.parse(time) * 60).toInt();
    }
    return -1;
  }

  static String formatDateTime(DateTime dateTime) {
    String s = "";
    s += "${dateTime.year}-${dateTime.month}-${dateTime.day}, ";
    if (dateTime.hour <= 12) {
      s += "${dateTime.hour}:${dateTime.minute}:${dateTime.second} AM";
    } else {
      s += "${dateTime.hour - 12}:${dateTime.minute}:${dateTime.second} PM";
    }
    return s;
  }

  static String getFileNameFromPathString(String path) {
    List<String> partsOfPath = path.split(".");
    return "${partsOfPath.elementAt(partsOfPath.length - 2)}.${partsOfPath.last}";
  }

  static Future<Image> resizeImage(/*Image image*/ String url,
      /*double newWidth, double newHeight*/ double scaleFactor) async {
    // PictureRecorder recorder = PictureRecorder();
    // Canvas canvas = Canvas(recorder);

    // Rect srcRect =
    //     Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    // Rect destRect = Rect.fromLTWH(0, 0, newWidth, newHeight);

    // canvas.drawImageRect(image, srcRect, destRect, Paint());

    // Picture picture = recorder.endRecording();
    // Future<Image> resizedImage =
    //     picture.toImage(newWidth.toInt(), newHeight.toInt());

    // return resizedImage;
    Image image = Image.network(url);
    Uint8List? bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();

    IMG.Image? img = IMG.decodeImage(bytes);
    IMG.Image resized = IMG.copyResize(img!,
        width: 200 /*image.width! ~/ scaleFactor*/,
        height: 200 /*image.height! ~/ scaleFactor*/);
    Uint8List? resizedImg = Uint8List.fromList(IMG.encodePng(resized));

    return Image.memory(resizedImg);
  }
}
