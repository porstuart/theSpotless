import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thespotless/jobTab.dart';
import 'package:thespotless/acceptedJobTab.dart';
import 'package:thespotless/profileTab.dart';
import 'package:thespotless/user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      JobTab(user: widget.user),
      AcceptedJob(user: widget.user),
      ProfileScreen(user: widget.user),
    ];
  }

  String $pagetitle = "The Spotless";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Jobs"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, ),
            title: Text("Accepted Job"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, ),
            title: Text("Profile"),
          )
        ],
      ),
    );
  }
}
