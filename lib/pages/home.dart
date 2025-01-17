import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/pages/counselorList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  // const Home({Key key, @required this.user}) : super(key: key);
  // final User user;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // bool isLoading;

  @override
  void initState() {
    super.initState();
    // isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final users = Provider.of<List<UsersChat>>(context);

    // print(users);
    // users.forEach((chat) {
    //   print(chat.name);
    //   print(chat.age);
    //   print(chat.role);
    // });

    return DefaultTabController(
      length: 6,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Curhat.in",
              style: TextStyle(
                  fontFamily: "AdreenaScript",
                  fontWeight: FontWeight.w800,
                  fontSize: 28),
              textWidthBasis: TextWidthBasis.parent,
            ),
            bottom: new TabBar(isScrollable: true, tabs: [
              Tab(text: 'Akademik'),
              Tab(text: 'Kebugaran'),
              Tab(text: 'Keluarga'),
              Tab(text: 'Finansial'),
              Tab(text: 'Asmara'),
              Tab(text: 'Lainnya')
            ]),
//            flexibleSpace: Container(
//              decoration: BoxDecoration(
//                  gradient: LinearGradient(
//                      begin: Alignment.topCenter,
//                      end: Alignment.bottomCenter,
//                      colors: <Color>[
//                        Color(0xFF8FEEBF),
//                        Color(0xFF17B7BD),
//                      ])
//              ),
//            ),
            backgroundColor: Color(0xFF17B7BD),
          ),
          body: new TabBarView(
            children: [
              CounselorList(
                type: 'akademik',
              ),
              CounselorList(
                type: 'kebugaran',
              ),
              CounselorList(
                type: 'keluarga',
              ),
              CounselorList(
                type: 'finansial',
              ),
              CounselorList(
                type: 'asmara',
              ),
              CounselorList(
                type: 'lainnya',
              ),
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
