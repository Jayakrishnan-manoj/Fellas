import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300,
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
    color: Color.fromRGBO(66, 110, 112, 1),
    width: 2,
  )),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
    color: Color(0xFF5F9EA0),
    width: 2,
  )),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
    color: Colors.red,
    width: 2,
  )),
);

void nextScreen(context, screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void nextScreenReplace(context, screen) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message!,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}

