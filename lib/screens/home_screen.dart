import 'dart:ffi';

import 'package:fellas/helper/helper_function.dart';
import 'package:fellas/screens/auth/login_screen.dart';
import 'package:fellas/screens/profile_page.dart';
import 'package:fellas/screens/search_screen.dart';
import 'package:fellas/services/auth.dart';
import 'package:fellas/widgets/group_tile.dart';
import 'package:fellas/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  String email = "";
  Auth auth = Auth();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmail().then(
      (value) {
        setState(() {
          email = value!;
        });
      },
    );
    await HelperFunctions.getUserName().then(
      (val) {
        setState(() {
          userName = val!;
        });
      },
    );
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Fellas",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => nextScreen(context, const SearchScreen()),
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
          ),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              leading: Icon(
                Icons.group,
                color: Colors.grey[700],
              ),
              selectedTileColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: () {},
              title: const Text(
                "Groups",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfileScreen(
                      userName: userName,
                      email: email,
                    ));
              },
              title: const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("LogOut"),
                        content: const Text("Are you sure you wanna logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await auth.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          )
                        ],
                      );
                    });
              },
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return AlertDialog(
                title: const Text(
                  "Create a Group",
                  textAlign: TextAlign.left,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : TextField(
                            onChanged: (val) {
                              setState(() {
                                groupName = val;
                              });
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(66, 110, 112, 1),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text("CANCEL"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (groupName != "") {
                        setState(() {
                          _isLoading = true;
                        });
                        Database(uid: FirebaseAuth.instance.currentUser!.uid)
                            .createGroup(
                          userName,
                          FirebaseAuth.instance.currentUser!.uid,
                          groupName,
                        )
                            .whenComplete(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackBar(context, Colors.green, "Group Created!");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text("Create Group"),
                  )
                ],
              );
            }),
          );
        });
  }

  groupList() {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  //int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                    groupId: getId(snapshot.data["groups"][index]),
                    groupName: getName(snapshot.data["groups"][index]),
                    userName: snapshot.data["fullName"],
                  );
                },
                itemCount: snapshot.data['groups'].length,
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
      stream: groups,
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[500],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Create groups and start connecting with your fellas!",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
