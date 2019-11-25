import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String email;

  MainScreen({Key key, this.email}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Successfully Login"),
    );
  }
}