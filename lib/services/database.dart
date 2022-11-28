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

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //creating a group

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId)async{
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  getGroupMembers(String groupId)async{
    return groupCollection.doc(groupId).snapshots();
  }

}
