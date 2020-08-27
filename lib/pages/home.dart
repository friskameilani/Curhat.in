import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/pages/counselorDetail.dart';
import 'package:curhatin/pages/counselorList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  // const Home({Key key, @required this.user}) : super(key: key);
  // final User user;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final users = Provider.of<List<UsersChat>>(context);

    print(users);
    users.forEach((chat) {
      print(chat.name);
      print(chat.age);
      print(chat.role);
    });
<<<<<<< HEAD

    return DefaultTabController(
      length: 6,
      child: Scaffold(
          appBar: AppBar(
            title: Text('${user.email}'),
            bottom: new TabBar(isScrollable: true, tabs: [
              Tab(text: 'Akademik'),
              Tab(text: 'Kebugaran'),
              Tab(text: 'Keluarga'),
              Tab(text: 'Finansial'),
              Tab(text: 'Asmara'),
              Tab(text: 'Lainnya')
            ]),
          ),
          body: new TabBarView(
            children: [
              CounselorList(
                type: 'Akademik',
=======
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.email}'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Colors.blue),
                  title: Text(users[index].name),
                  subtitle: Text(users[index].role),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CounselorDetail(detail: users[index])));
                  },
                ),
>>>>>>> 7cc685083912b16b3b844bba9a509e03d980f0f9
              ),
              ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: Colors.blue),
                          title: Text(users[index].name),
                          subtitle: Text(users[index].role),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CounselorDetail(detail: users[index])));
                          },
                        ),
                      ),
                    );
                  }),
              ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: Colors.blue),
                          title: Text(users[index].name),
                          subtitle: Text(users[index].role),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CounselorDetail(detail: users[index])));
                          },
                        ),
                      ),
                    );
                  }),
              Text('Hello'),
              Text('Hello'),
              Text('Hello')
            ],
          )),
    );
  }

  Center checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['role'] == 'admin') {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
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
