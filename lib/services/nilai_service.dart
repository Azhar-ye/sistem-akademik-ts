import 'package:cloud_firestore/cloud_firestore.dart';

class NilaiService {
  final _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> streamNilai() {
    return _db
        .collection("nilai")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> addNilai({
    required String nama,
    required String nim,
    required String matkul,
    required int nilai,
  }) async {
    await _db.collection("nilai").add({
      "nama": nama,
      "nim": nim,
      "matkul": matkul,
      "nilai": nilai,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNilai({
    required String id,
    required String nama,
    required String nim,
    required String matkul,
    required int nilai,
  }) async {
    await _db.collection("nilai").doc(id).update({
      "nama": nama,
      "nim": nim,
      "matkul": matkul,
      "nilai": nilai,
    });
  }

  Future<void> deleteNilai(String id) async {
    await _db.collection("nilai").doc(id).delete();
  }
}
