import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:team_up/constants/student_data.dart';

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

  /// Performs parsing so document snapshot can be transferred to List<Map<String, dynamic>>
  /// Also provides time query filters if needed, enter -1 if not needed
  Future<List<Map<String, dynamic>>> parseStudentTaskData(
      DocumentSnapshot<Map<String, dynamic>>? docSnapshot, int time) async {
    List<Map<String, dynamic>> fieldResults = [];
    FlutterLogs.logInfo(
        "Cloud Firestore Database", "GET Operation", "In parse student data");
    FlutterLogs.logInfo("Cloud Firestore Database", "GET Operation",
        "Got data: ${docSnapshot!.data()}");
    Map<String, dynamic>? data = docSnapshot.data();
    List<dynamic> listData = data!['tasks'];
    for (Map<String, dynamic> mapData in listData) {
      if (time == -1) {
        fieldResults.add(mapData);
      } else if (mapData['estimated time'] == '$time mins') {
        fieldResults.add(mapData);
      }
    }
    FlutterLogs.logInfo("Cloud Firestore Database", "GET Operation",
        "Adding string to field results: ${data['tasks']}");

    return fieldResults;
  }

  Future<List<Map<String, dynamic>>?> /* Future<List<String>>*/
      getStudentTasks() async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("student tasks", StudentData.studentEmail);

    if (docSnapshot != null) {
      return parseStudentTaskData(docSnapshot, -1);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getAvailableTasks(
      int time, String subteam) async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("Tasks", subteam);

    if (docSnapshot != null) {
      return parseStudentTaskData(docSnapshot, time);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getStudentSubmissions() async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("submissions", StudentData.studentEmail);

    if (docSnapshot != null) {
      return parseStudentTaskData(docSnapshot, -1);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getPotentialTeam(String team_number) async {
    DocumentSnapshot<Map<String, dynamic>>? docSnapshot =
        await getDocumentByID("Teams", team_number);

    if (docSnapshot != null) {
      return docSnapshot.data();
    }
    return null;
  }
}
