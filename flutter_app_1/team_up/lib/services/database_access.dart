import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseAccess {
  static DatabaseAccess? _instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Singleton constructor
  static DatabaseAccess getInstance() {
    _instance ??= DatabaseAccess._internal();
    return _instance!;
  }

  DatabaseAccess._internal();

  /// collectionId -- the category of this entry (ex. "tasks")
  /// docId -- name describing the entry (ex. "Assemble robot drivetrain")
  /// data -- details of task (time, skills needed)
  void addToDatabase(
      String collectionId, String docId, Map<String, dynamic> data) {
    // Adds the data to the appropriate location through its path
    // Merges data that may have been in previously
    db.collection(collectionId).doc(docId).set(data, SetOptions(merge: true));
  }
}
