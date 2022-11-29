import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fellas/screens/group_info_screen.dart';
import 'package:fellas/services/database.dart';
import 'package:fellas/widgets/message_tile.dart';
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
  String admin = "";
  TextEditingController chatController = TextEditingController();

  @override
  void initState() {
    setState(() {
      getChatAndAdmin();
    });
    super.initState();
  }

  getChatAndAdmin() {
    Database().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    Database().getGroupAdmin(widget.groupId).then((value) {
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
              nextScreen(
                  context,
                  GroupInfoScreen(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: admin,
                  ));
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Send a Text....",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.username ==
                          snapshot.data.docs[index]['sender'],
                    );
                  },
                )
              : Container();
        });
  }

  sendMessage() {
    if (chatController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": chatController.text,
        "sender": widget.username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      Database().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        chatController.clear();
      });
    }
  }
}
