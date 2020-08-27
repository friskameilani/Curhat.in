import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/services/database.dart';
import 'package:flutter/material.dart';
import 'package:curhatin/pages/home.dart';
import 'package:curhatin/pages/chat.dart';
import 'package:curhatin/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class TabRoutes extends StatefulWidget {
  const TabRoutes({Key key, @required this.user}) : super(key: key);
  final User user;
  @override
  _TabRoutesState createState() => _TabRoutesState();
}

class _TabRoutesState extends State<TabRoutes> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UsersChat>>.value(
      value: DatabaseServices().users,
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(widget.user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text("Loading...");
            default:
              return checkRole(snapshot.data);
          }
        },
      ),
    );
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['role'] == 'admin') {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // new Container(
              //     child: Home(
              //   user: widget.user,
              // )),
              new Container(
                child: ChatPage(),
              ),
              new Container(
                child: ProfilePage(),
              ),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              // Tab(
              //   icon: new Icon(Icons.home),
              //   child: Text(
              //     'Home',
              //     style: TextStyle(fontSize: 12),
              //   ),
              // ),
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
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              new Container(child: Home()),
              new Container(
                child: ChatPage(),
              ),
              new Container(
                child: ProfilePage(),
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

  Center adminPage(DocumentSnapshot snapshot) {
    return Center(
        child: Text(snapshot.data['role'] + '' + snapshot.data['name']));
  }

  Center userPage(DocumentSnapshot snapshot) {
    return Center(child: Text(snapshot.data['name']));
  }
}
