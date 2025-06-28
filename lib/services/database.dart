import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addTodayWork(Map<String, dynamic> req, String id) async {
    return await FirebaseFirestore.instance
        .collection("Today")
        .doc(id)
        .set(req);
  }

  Future addTomorrowWork(Map<String, dynamic> req, String id) async {
    return await FirebaseFirestore.instance
        .collection("Tomorrow")
        .doc(id)
        .set(req);
  }

  Future addNextWeekWork(Map<String, dynamic> req, String id) async {
    return await FirebaseFirestore.instance
        .collection("NextWeek")
        .doc(id)
        .set(req);
  }

  Future<Stream<QuerySnapshot>> getAllTodos(String req) async {
    return await FirebaseFirestore.instance.collection(req).snapshots();
  }

  Future updateTick(String id, day) async {
    return await FirebaseFirestore.instance.collection(day).doc(id).update({
      "Yes": true,
    });
  }
}
