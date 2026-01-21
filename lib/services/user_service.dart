import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> createUserIfNotExists() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _db.collection("users").doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        "email": user.email ?? "",
        "role": "user", // default
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String> getRole() async {
    final user = _auth.currentUser;
    if (user == null) return "user";

    final doc = await _db.collection("users").doc(user.uid).get();
    if (!doc.exists) return "user";

    return doc.data()?["role"] ?? "user";
  }
}
