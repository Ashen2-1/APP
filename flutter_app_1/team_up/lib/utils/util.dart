import '../services/database_access.dart';

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

  static Future<List<Map<String, dynamic>>> combineTaskIntoExisting(
      Map<String, dynamic> taskToAdd,
      List<Map<String, dynamic>>? prevTasks) async {
    if (prevTasks != null) {
      if (!Util.isTaskIn(taskToAdd['task'], prevTasks)) {
        prevTasks.add(taskToAdd);
      }
    } else {
      prevTasks = [taskToAdd];
    }

    return prevTasks;
  }
}
