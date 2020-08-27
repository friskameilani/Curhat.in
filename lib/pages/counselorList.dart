import 'package:curhatin/models/usersChat.dart';
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
    var users = Provider.of<List<UsersChat>>(context);
    users.forEach((element) {
      if (element.type != widget.type) {
        users.remove(element);
      }
    });
    return ListView.builder(
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
        });
  }
}
