import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';

class Database {
  final String? uid;
  Database({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set(
      {
        "fullName": fullName,
        "email": email,
        "groups": [],
        "profilePic": "",
        "uid": uid,
      },
    );
  }
}
