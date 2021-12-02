import 'package:flutter/material.dart';
import 'package:socket_chat_app/screens/signup_login.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpLogin(),
    );
  }
}

