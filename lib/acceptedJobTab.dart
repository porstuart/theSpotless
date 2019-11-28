import 'package:flutter/material.dart';
import 'user.dart';

class AcceptedJob extends StatefulWidget {
  final User user;

  AcceptedJob({Key key, this.user});

  @override
  _AcceptedJobState createState() => _AcceptedJobState();
}

class _AcceptedJobState extends State<AcceptedJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.cyan[500],
                  Colors.cyan[500],
                  Colors.cyan[400],
                  Colors.cyan[300],
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 60.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Please login first to see your accepted job",
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
