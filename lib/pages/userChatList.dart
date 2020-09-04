import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/pages/chat.dart';
import 'package:curhatin/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserChatList extends StatefulWidget {
  @override
  _UserChatListState createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  final ScrollController scrollController = ScrollController();

  var userData;
  var newList;
  @override
  void initState() {
    userData = Provider.of<User>(context, listen: false);
    _getUsersChatList();
    super.initState();
  }

  _getUsersChatList() async {
    try {
      var lists = Firestore.instance
          .collection('users')
          .document(userData.uid)
          .snapshots()
          .asyncMap((snap) async {
        List array = snap.data['isChattingWith'];
        var users = [];
        for (var user in array) {
          users.add(await Firestore.instance.document(user).get());
        }
        return users;
      });
      // DatabaseServices(uid: userData.uid).userData;
      // print(userData.isChattingWith);
      print('List=');
      print(lists);
    } catch (e) {}
  }

  getUsersChatList() {
    return Center(
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(userData.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent)),
              );
            } else if (snapshot.data['isChattingWith'] != null) {
              print(snapshot.data['isChattingWith']);
              List currentlyChatting =
                  List.from(snapshot.data['isChattingWith']);
              List<String> id = [];
              currentlyChatting.forEach((element) {
                id.add(element['id'].toString());
              });
              // snapshot.data['isChattingWith']?.foreach((item) async {
              //   currentlyChatting.add(item);
              // });
              print(currentlyChatting);
              print(id);
              return StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .where('uid', whereIn: id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  } else {
                    List<UsersChat> users = [];
                    var usersMapped = snapshot.data.documents.map((doc) {
                      users.add(UsersChat(
                        uid: doc.data['uid'] ?? '',
                        name: doc.data['name'] ?? '',
                        age: doc.data['age'] ?? 0,
                        role: doc.data['role'] ?? '',
                        type: doc.data['type'] ?? '',
                      ));
                    });
                    usersMapped.toString();
                    users.forEach((element) {
                      print(element.name);
                    });

                    print('helo');
                    return ListView.builder(
                      itemCount: users.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Card(
                              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                              child: ListTile(
                                leading:
                                    CircleAvatar(backgroundColor: Colors.blue),
                                title: Text(users[index].name),
                                subtitle: Text(users[index].role),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                              recieverData: users[index])));
                                },
                              ),
                            ));
                      },
                      controller: scrollController,
                    );
                  }
                },
              );
            }
          }),
    );
  }

  Widget build(BuildContext context) {
    // print(userData.isChattingWith);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Yaharo'),
      ),
      body: Column(
        children: [getUsersChatList()],
      ),
    );
  }
}
