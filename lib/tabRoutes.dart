import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/pages/feeds.dart';
import 'package:curhatin/pages/userChatList.dart';
import 'package:curhatin/services/database.dart';
import 'package:flutter/material.dart';
import 'package:curhatin/pages/home.dart';
import 'package:curhatin/pages/chat.dart';
import 'package:curhatin/pages/profile.dart';
import 'package:provider/provider.dart';

class TabRoutes extends StatefulWidget {
  // const TabRoutes({Key key, @required this.user}) : super(key: key);
  // final User user;
  @override
  _TabRoutesState createState() => _TabRoutesState();
}

User user;

class _TabRoutesState extends State<TabRoutes> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
    DatabaseServices(uid: user.uid).makeUserOnline();
    WidgetsBinding.instance.addObserver(this);
    // DatabaseServices(uid: user.uid).updateUserData(uid, name, dept, age)
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DatabaseServices(uid: user.uid).makeUserOnline();
      print('online');
    } else {
      DatabaseServices(uid: user.uid).makeUserOffline();
      print('offline');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UsersChat>>.value(
      value: DatabaseServices().users,
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              );
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
                child: UserChatList(),
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
                child: FeedPage(),
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
                icon: new Icon(Icons.chrome_reader_mode),
                child: Text(
                  'Articles',
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
            labelColor: Color(0xFF17B7BD),
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
