import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends StatefulWidget {
//  final String admin;
  @override
  _ChatPageState createState() => _ChatPageState();
  final UsersChat recieverData;
  ChatPage({this.recieverData});
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isLoading;

  // SharedPreferences preferences;

  String chatId;
  User senderData;
  var listMessage;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    senderData = Provider.of<User>(context, listen: false);
    // });
    print('Sender Data =');
    print(senderData);
    getChatId();
  }

  // readLocal() async {
  //   preferences = await SharedPreferences.getInstance();
  // }

  getChatId() async {
    if (senderData.uid.hashCode <= widget.recieverData.uid.hashCode) {
      chatId = '${senderData.uid}-${widget.recieverData.uid}';
    } else {
      chatId = '${widget.recieverData.uid}-${senderData.uid}';
    }
    Firestore.instance
        .collection('users')
        .document(senderData.uid)
        .updateData({'isChattingWith': widget.recieverData.uid});
  }

  void onMessageSent(String contentMsg) {
    if (contentMsg != null) {
      textEditingController.clear();
      var docRef = Firestore.instance
          .collection('messages')
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(docRef, {
          "idFrom": senderData.uid,
          "idTo": widget.recieverData.uid,
          "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "content": contentMsg,
        });
        scrollController.animateTo(0.0,
            duration: Duration(microseconds: 300), curve: Curves.easeOut);
      });
    } else {
      Fluttertoast.showToast(msg: 'You Can\'t send an empty message');
    }
  }

  @override
  Widget build(BuildContext context) {
    // var senderData = Provider.of<User>(context);

    createListMessages() {
      return Flexible(
          child: chatId == ''
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.lightBlueAccent)),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('messages')
                      .document(chatId)
                      .collection(chatId)
                      .orderBy('timestamp', descending: true)
                      .limit(20)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightBlueAccent)),
                      );
                    } else {
                      listMessage = snapshot.data.documents;
                      // return ListView.builder(
                      //   // itemBuilder: null
                      //   // itemCount: snapshot.data.length,
                      //   reverse: true,
                      //   controller: scrollController,
                      // );
                    }
                  },
                ));
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: widget.recieverData.name,
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nFMIPA 54',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ]),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 220,
              ),
              // createListMessages(),
              // input controllers
              createInput(),
              // Text(widget.recieverData.uid),
            ],
          ),
        ));
  }

  createInput() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF17B7BD),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: TextField(
            decoration: new InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.white,
                  onPressed: () => onMessageSent(textEditingController.text),
                ),
                contentPadding: EdgeInsets.only(left: 20),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(20.0),
                  ),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(color: Colors.white70, fontSize: 15),
                hintText: "Type Something...",
                fillColor: Colors.transparent),
            controller: textEditingController,
          ),
        ),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.transparent, width: 0)),
        ));
  }
}
