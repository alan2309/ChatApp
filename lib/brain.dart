import 'package:cloud_firestore/cloud_firestore.dart';

class Brain {
  getUser(String username) {
    FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username);
  }

  uploadUser(userData) {
    FirebaseFirestore.instance.collection("users").add(userData);
  }
}
