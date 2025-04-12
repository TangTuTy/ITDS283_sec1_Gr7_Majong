import 'package:cloud_firestore/cloud_firestore.dart';

class Campusdb {
  final CollectionReference campus = FirebaseFirestore.instance.collection(
    "campus",
  );
  Stream<QuerySnapshot> getcampus() {
    final campusstream = campus.snapshots();
    return campusstream;
  }
}
