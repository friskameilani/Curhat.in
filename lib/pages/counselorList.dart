import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/pages/chat.dart';
import 'package:curhatin/services/database.dart';
import 'package:flutter/material.dart';

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
          return Container(
            alignment: Alignment.center,
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot?.data?.length ?? 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: ListTile(
                      leading: Container(
                        constraints:
                            BoxConstraints(maxHeight: 45, maxWidth: 45),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFF17B7BD),
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/user-boy.png'),
                                backgroundColor: Colors.white,
                                radius: 17.0,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        snapshot.data[index].status == 'online'
                                            ? Colors.green
                                            : Colors.red),
                              ),
                            )
                          ],
                        ),
                      ),
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].status),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    recieverData: snapshot.data[index])));
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
