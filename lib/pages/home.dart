import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key key, @required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UsersChat>>(context);
    users.forEach((chat) {
      print(chat.name);
      print(chat.age);
      print(chat.role);
    });
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Home ${user.email}'),
//      ),
      body: StreamBuilder<DocumentSnapshot>(
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
              return Text('Loading ...');
            default:
              return checkRole(snapshot.data);
          }
        },
      ),
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
