import 'package:fellas/services/auth.dart';
import 'package:fellas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_page.dart';

class AppDrawer extends StatelessWidget {
  String userName;
  String email;
  bool isSelected;
  AppDrawer(
      {Key? key,
      required this.userName,
      required this.email,
      required this.isSelected});

  Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            selected: isSelected,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            onTap: () {
              nextScreenReplace(context, const HomeScreen());
            },
            title: const Text(
              "Groups",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.grey[700],
            ),
            selectedTileColor: Theme.of(context).primaryColor,
            selected: !isSelected,
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
    );
  }
}
