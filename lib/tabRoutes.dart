import 'package:flutter/material.dart';
import 'package:curhatin/pages/home.dart';
import 'package:curhatin/pages/chat.dart';
import 'package:curhatin/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabRoutes extends StatefulWidget {
  @override
  _TabRoutesState createState() => _TabRoutesState();
}

class _TabRoutesState extends State<TabRoutes> {

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            new Container(child: Home()),
            new Container(child: ChatPage(),),
            new Container(child: ProfilePage(),
            ),
        ],
      ),
        bottomNavigationBar: new TabBar(
          tabs: [
            Tab(
              icon: new Icon(Icons.home),
              child: Text(
                'Home',
                style: TextStyle(fontSize: 12),
              ),
            ),
            Tab(
              icon: new Icon(Icons.message),
              child: Text(
                'Chat',
                style: TextStyle(fontSize: 12),
              ),
            ),
            Tab(
              icon: new Icon(Icons.person),
              child: Text(
                'Profile',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
          labelColor: Colors.greenAccent,
          unselectedLabelColor: Colors.grey[700],
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.transparent,
        ),
      ),
    );
  }
}