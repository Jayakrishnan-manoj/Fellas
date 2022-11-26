import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';

class Database {
  final String? uid;
  Database({this.uid});

  //reference for collections

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //saveing user data on sign in

  Future saveUserData(String fullName, String email) async {
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

  //getting user data on login

  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //getting user groups

  getUserGroups()async{
    return userCollection.doc(uid).snapshots();
  }
}
