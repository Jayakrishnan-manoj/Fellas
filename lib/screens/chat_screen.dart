import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fellas/screens/group_info_screen.dart';
import 'package:fellas/services/database.dart';
import 'package:fellas/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String username;
  const ChatScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.username,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chats;
  String admin ="";

  @override
  void initState() {
    setState(() {
      getChatAndAdmin();
    });
    super.initState();
  }

  getChatAndAdmin(){
    Database().getChats(widget.groupId).then((val){
      setState(() {
        chats = val;
      });
    });
    Database().getGroupAdmin(widget.groupId).then((value){
      setState(() {
        admin = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, GroupInfoScreen(groupId: widget.groupId,groupName: widget.groupName,adminName: admin,));
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
    );
  }
}
