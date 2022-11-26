import 'package:fellas/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: ()=>auth.signOut(),
          child: Text("Log out"),
        ),
      ),
    );
  }
}
