import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';
import 'package:team_up/utils/util.dart';

import '../widgets/reusable_widgets/reusable_widget.dart';
import 'internet_connection.dart';

class DatabaseAccess {
  static DatabaseAccess? _instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Map<String, dynamic>? curData;

  // Singleton constructor
  static DatabaseAccess getInstance() {
    _instance ??= DatabaseAccess._internal();
    return _instance!;
  }

  DatabaseAccess._internal();

  /// collectionId -- the category of this entry (ex. "tasks")
  /// docId -- subteam (ex. "Programming")
  /// data -- details of task (task title, time, skills needed, instructions)
  void addToDatabase(
      String collectionId, String docId, Map<String, dynamic> data) {
    // Adds the data to the appropriate location through its path
    // Merges data that may have been in previously
    db.collection(collectionId).doc(docId).set(data, SetOptions(merge: true));
  }

  void updateField(
      String collectionId, String docId, Map<String, dynamic> data) {
    db.collection(collectionId).doc(docId).update(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> query(
      String collectionId, String queryCategory, Object item) async {
    QuerySnapshot<Map<String, dynamic>>? res;
    FlutterLogs.logInfo("Cloud Firestore Database", "GET Operation",
        "Getting for: $collectionId, $queryCategory, $item");
    await db
        .collection(collectionId)
        .where(queryCategory, isEqualTo: item)
        .get()
        .then((querySnapshot) {
      FlutterLogs.logInfo(
          "Cloud Firestore Database", "GET Operation", "Sucessfully got");
      res = querySnapshot;
      // for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
      //     in querySnapshot.docs) {
      //   FlutterLogs.logInfo("Cloud Firestore Database", "GET Operation",
      //       "Got data: ${docSnapshot.data()}");
      //docSnapshot.data();
      // for (String item in data.keys) {
      //   res += "$item: ${data[item]}, ";
      // }
    }
            // FlutterLogs.logInfo(
            //     "Cloud Firestore Database", "GET Operation", "Output string: $res");
            );
    return res;
  }

  List<String> parseData(
      String searchField, QuerySnapshot<Map<String, dynamic>>? querySnapshot) {
    List<String> fieldResults = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
        in querySnapshot!.docs) {
      FlutterLogs.logInfo("Cloud Firestore Database", "GET Operation",
          "Got data: ${docSnapshot.data()}");
      Map<String, dynamic> data = docSnapshot.data();
      fieldResults.add(data[searchField]);
      FlutterLogs.logInfo("Cloud Firestore Database", "GET Operation",
          "Adding string to field results: ${data[searchField]}");
    }
    return fieldResults;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getDocumentByID(
      String collection, String docId) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await db.collection(collection).doc(docId).get();

    if (docSnapshot.exists) {
      return docSnapshot;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllDocuments(String collection) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection(collection).get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Performs parsing so document snapshot can be transferred to List<Map<String, dynamic>>
  /// Also provides time query filters if needed, enter "" if not needed
  Future<List<Map<String, dynamic>>> parseStudentTaskData(
      DocumentSnapshot<Map<String, dynamic>>? docSnapshot, String time) async {
    List<Map<String, dynamic>> fieldResults = [];
    FlutterLogs.logInfo(
        "Cloud Firestore Database", "GET Operation", "In parse student data");
    FlutterLogs.logInfo("Cloud Firestore Database", "GET Operation",
        "Got data: ${docSnapshot!.data()}");
    Map<String, dynamic>? data = docSnapshot.data();
    if (data!.isNotEmpty) {
      List<dynamic> listData = data['tasks'];
      for (Map<String, dynamic> mapData in listData) {
        if (time == "") {
          fieldResults.add(mapData);
        } else {
          List<String> times = Util.getTimeInRange(time);
          for (String time in times) {
            if (mapData['estimated time'] == time) {
              fieldResults.add(mapData);
            }
          }
        }
        FlutterLogs.logInfo("Cloud Firestore Database", "GET Operation",
            "Adding string to field results: ${data['tasks']}");
      }
    }
    return fieldResults;
  }

  Future<dynamic> getField(
      String collectionId, String docId, String mapKey) async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID(collectionId, docId);

    if (docSnapshot != null) {
      Map<String, dynamic>? data = docSnapshot.data();
      return data![mapKey];
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> /* Future<List<String>>*/
      getStudentTasks() async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("student tasks", "signed up");
    List<Map<String, dynamic>> fieldResults = [];

    if (docSnapshot != null) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data!.isNotEmpty) {
        List<dynamic> listData = data['tasks'];
        for (Map<String, dynamic> mapData in listData) {
          if (mapData['completer'] == StudentData.studentEmail &&
              mapData['studentViewable']) {
            fieldResults.add(mapData);
          }
        }
      }
    }
    FlutterLogs.logInfo("Hi", "ERROR", fieldResults.toString());
    return fieldResults;
  }

  Future<List<Map<String, dynamic>>?> getAvailableTasks(
      String time, String subteam) async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("Tasks", subteam);

    List<Map<String, dynamic>> fieldResults = [];

    if (docSnapshot != null) {
      List<Map<String, dynamic>> results =
          await parseStudentTaskData(docSnapshot, time);
      for (Map<String, dynamic> mapData in results) {
        if (mapData['team number'] ==
            await StudentData.getStudentTeamNumber()) {
          if (mapData['due date'].seconds > Timestamp.now().seconds) {
            fieldResults.add(mapData);
          } else {
            // Remove overdue tasks
            List<Map<String, dynamic>> copy = [];
            for (Map<String, dynamic> map in results) {
              copy.add(map);
            }
            copy.removeWhere((element) => element == mapData);
            DatabaseAccess.getInstance()
                .addToDatabase("Tasks", subteam, {'tasks': copy});

            if (mapData['isForAll'] != null && !(mapData['isForAll'])) {
              List<dynamic> databaseGet = await DatabaseAccess.getInstance()
                  .getField("Tasks", "outstanding", "tasks");
              mapData['subteam'] = subteam;
              List<Map<String, dynamic>> res = Util.combineTaskIntoExisting(
                  mapData, databaseGet.cast<Map<String, dynamic>>());
              DatabaseAccess.getInstance()
                  .addToDatabase("Tasks", "outstanding", {"tasks": res});
            }
          }
        }
      }
    }
    return fieldResults;
  }

  Future<List<Map<String, dynamic>>> getUnassignedTasks() async {
    List<dynamic> unassigned = await DatabaseAccess.getInstance()
        .getField("Tasks", "outstanding", "tasks");

    List<Map<String, dynamic>> res = [];
    for (Map<String, dynamic> map in unassigned.cast<Map<String, dynamic>>()) {
      if (map['assigner'] == StudentData.studentEmail) {
        res.add(map);
      }
    }

    return res;
  }

  Future<List<Map<String, dynamic>>> getAllUnassignedTasks() async {
    List<dynamic> unassigned = await DatabaseAccess.getInstance()
        .getField("Tasks", "outstanding", "tasks");

    return unassigned.cast<Map<String, dynamic>>();
  }

  Future<int> getNumberOfSubteamTasks(String subteam) async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("Tasks", subteam);

    int taskCounter = 0;

    if (docSnapshot != null) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data!.isNotEmpty) {
        List<dynamic> listData = data['tasks'];
        for (Map<String, dynamic> mapData in listData) {
          if (mapData['team number'] ==
                  await StudentData.getStudentTeamNumber() &&
              mapData['due date'].seconds > Timestamp.now().seconds) {
            taskCounter += 1;
          }
        }
      }
    }
    return taskCounter;
  }

  Future<List<Map<String, dynamic>>?> getAllTasks(String subteam) async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("Tasks", subteam);

    if (docSnapshot != null) {
      return parseStudentTaskData(docSnapshot, "");
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getMyCreatedTasksInProgress() async {
    List<Map<String, dynamic>> res = [];

    for (Map<String, dynamic> task
        in (await DatabaseAccess.getInstance().getAllSignedUpTasks())!) {
      if (task['assigner'] == StudentData.studentEmail &&
          task['studentViewable']) {
        res.add(task);
      }
    }
    return res;
  }

  Future<List<Map<String, dynamic>>?> getMyAssignedStudentSubmissions() async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("student tasks", 'signed up');

    List<Map<String, dynamic>> fieldResults = [];

    if (docSnapshot != null) {
      Map<String, dynamic>? data = docSnapshot.data();
      if (data!.isNotEmpty) {
        List<dynamic> listData = data['tasks'];
        for (Map<String, dynamic> mapData in listData) {
          if (((mapData['completed'] ||
                  (mapData['finish time'] != null &&
                      Timestamp.now().seconds >
                          mapData['finish time'].seconds)) &&
              !mapData['approved'] &&
              mapData['assigner'] == StudentData.studentEmail)) {
            fieldResults.add(mapData);
          }
        }
      }
    }
    return fieldResults;
  }

  Future<Map<String, dynamic>?> getPotentialTeam(String team_number) async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("Teams", team_number);

    if (docSnapshot != null) {
      return docSnapshot.data();
    }
    return null;
  }

  Future<Map<String, dynamic>?> getStudentStats() async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("student tasks", StudentData.studentEmail);

    if (docSnapshot != null) {
      return docSnapshot.data();
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAllSignedUpTasks() async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("student tasks", "signed up");

    if (docSnapshot != null) {
      return parseStudentTaskData(docSnapshot, "");
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllStudentsPartOfTeam(
      String teamNumber) async {
    List<Map<String, dynamic>> res = [];
    for (Map<String, dynamic> student
        in await getAllDocuments("student tasks")) {
      if (student['team number'] == teamNumber) {
        res.add(student);
      }
    }
    return res;
  }
}
