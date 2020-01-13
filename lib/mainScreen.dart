import 'package:flutter/material.dart';
import 'package:thespotless/mypost.dart';
import 'package:thespotless/joblist.dart';
import 'package:thespotless/myjob.dart';
import 'package:thespotless/profile.dart';
import 'package:thespotless/laundry.dart';

class MainScreen extends StatefulWidget {
  final Laundry laundry;

  const MainScreen({Key key,this.laundry}) : super(key: key);

  
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
      JobList(laundry: widget.laundry),
      MyJob(laundry: widget.laundry),
      MyPost(laundry: widget.laundry),
      Profile(laundry: widget.laundry),
    ];
  }
  
  String $pagetitle = "My Pickup";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        //backgroundColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,

        items: [
          
          BottomNavigationBarItem(
            icon: Icon(Icons.list, ),
            title: Text("Job List"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, ),
            title: Text("My Job"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, ),
            title: Text("My Post"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person ),
            title: Text("Profile"),
          ),
        ],
      ),
      );
  }
  }
