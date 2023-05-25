import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_logs/flutter_logs.dart';

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
}
