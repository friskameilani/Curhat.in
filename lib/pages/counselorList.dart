import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counselorDetail.dart';

class CounselorList extends StatefulWidget {
  @override
  _CounselorListState createState() => _CounselorListState();
  final String type;
  CounselorList({this.type});
}

class _CounselorListState extends State<CounselorList> {
  @override
  Widget build(BuildContext context) {
    // var users = Provider.of<List<UsersChat>>(context);
    // users.forEach((element) {
    //   if (element.type != widget.type) {
    //     users.remove(element);
    //   }
    // });
    return StreamBuilder<List<UsersChat>>(
      stream: DatabaseServices(type: widget.type).users,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new Text('Error');
        } else if (snapshot.data == null) {
          return Text('Still Waiting...');
        } else {
          return ListView.builder(
              itemCount: snapshot?.data?.length ?? 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.blue),
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].role),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CounselorDetail(
                                    detail: snapshot.data[index])));
                      },
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}
