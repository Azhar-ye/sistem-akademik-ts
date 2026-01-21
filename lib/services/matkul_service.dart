import 'package:cloud_firestore/cloud_firestore.dart';

class MatkulService {
  final _db = FirebaseFirestore.instance;

  
  Stream<QuerySnapshot> streamMatkul() {
    return _db.collection("matkul").snapshots();
  }

  Future<void> addMatkul(String nama) async {
    await _db.collection("matkul").add({
      "nama": nama,
      "createdAt": FieldValue.serverTimestamp(), // optional tapi bagus
    });
  }

  Future<void> deleteMatkul(String id) async {
    await _db.collection("matkul").doc(id).delete();
  }
}
