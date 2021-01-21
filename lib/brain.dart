import 'package:cloud_firestore/cloud_firestore.dart';

class Brain {
  getUser(String email) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email);
  }

  uploadUser(userData) {
    FirebaseFirestore.instance.collection("users").add(userData);
  }

  uploadChats(chat) {
    FirebaseFirestore.instance.collection("chats").add(chat);
  }
}
