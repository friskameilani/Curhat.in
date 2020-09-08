import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleUserChat extends StatefulWidget {
  @override
  _SingleUserChatState createState() => _SingleUserChatState();
  const SingleUserChat({Key key, @required this.recieverUser})
      : super(key: key);
  final UsersChat recieverUser;
}

class _SingleUserChatState extends State<SingleUserChat> {
  User senderUser;
  String chatId;
  @override
  void initState() {
    super.initState();
    senderUser = Provider.of<User>(context, listen: false);
    getChatId();
  }

  getChatId() async {
    if (senderUser.uid.hashCode <= widget.recieverUser.uid.hashCode) {
      chatId = '${senderUser.uid}-${widget.recieverUser.uid}';
    } else {
      chatId = '${widget.recieverUser.uid}-${senderUser.uid}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('messages')
          .document(chatId)
          .collection(chatId)
          .orderBy('timeStamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          print('data is null');
          return Center();
        } else {
          print('hello');
          var docList = snapshot.data.documents;
          print(docList.last.data);

          return ListTile(
            leading: CircleAvatar(backgroundColor: Colors.blue),
            title: Text(widget.recieverUser.name),
            subtitle: Text(docList.last.data['content']),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatPage(recieverData: widget.recieverUser)));
            },
          );
        }
      },
    );
  }
}
