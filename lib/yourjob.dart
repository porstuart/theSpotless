import 'package:flutter/material.dart';
import 'package:thespotless/mainscreen.dart';

class YourJob extends StatefulWidget {
  @override
  _YourJobState createState() => _YourJobState();
}

class _YourJobState extends State<YourJob> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Your Job'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Container(
              child: Text('Your Job'),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
    return Future.value(false);
  }
}
