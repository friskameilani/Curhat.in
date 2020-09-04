import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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
    // var list = List<String>;

    Firestore.instance
        .collection('users')
        .document(widget.recieverData.uid)
        .updateData({
      'isChattingWith': FieldValue.arrayUnion([
        {'id': senderData.uid}
      ])
    });
    // Firestore.instance
    //     .collection('users')
    //     .document(senderData.uid)
    //     .updateData({'isChattingWith': widget.recieverData.uid});
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
                      .orderBy('timeStamp', descending: true)
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
                      print('Chat Id =' + chatId);
                      listMessage = snapshot.data.documents;
                      print('List Messages');
                      print(listMessage);
                      return ListView.builder(
                        itemBuilder: (context, index) =>
                            createItem(index, snapshot.data.documents[index]),
                        itemCount: snapshot?.data?.documents?.length,
                        reverse: true,
                        controller: scrollController,
                      );
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
        body: Column(
          // child: Stack(
          children: <Widget>[
            // Container(
            //   height: MediaQuery.of(context).size.height - 220,
            // ),
            createListMessages(),
            // input controllers
            createInput(),
            // Text(widget.recieverData.uid),
          ],
          // ),
        ));
  }

  Widget createItem(int index, DocumentSnapshot documentSnapshot) {
    if (documentSnapshot['idFrom'] == senderData.uid) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(documentSnapshot['content'],
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200,
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(15.0)),
            margin: EdgeInsets.only(
                bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }
  }

  isLastMsgLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == senderData.uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  isLastMsgRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != senderData.uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
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
          // margin: EdgeInsets.only(left: 10, right: 10),
          // child: Container(
          //   decoration: BoxDecoration(
          //     color: Color(0xFF17B7BD),
          //     borderRadius: BorderRadius.all(Radius.circular(80.0)),
          //   ),
          //   child: TextField(
          //     decoration: new InputDecoration(
          //         suffixIcon: IconButton(
          //           icon: Icon(Icons.send),
          //           color: Colors.white,
          //           onPressed: () {},
          //         ),
          //         contentPadding: EdgeInsets.only(left: 20),
          //         border: new OutlineInputBorder(
          //           borderRadius: const BorderRadius.all(
          //             const Radius.circular(20.0),
          //           ),
          //           borderSide: BorderSide(
          //             width: 0,
          //             style: BorderStyle.none,
          //           ),
          //         ),
          //         filled: true,
          //         hintStyle: new TextStyle(color: Colors.white70, fontSize: 15),
          //         hintText: "Type Something...",
          //         fillColor: Colors.transparent),
          //   ),
          //   width: double.infinity,
          //   height: 50,
          //   // decoration: BoxDecoration(
          //   //   border: Border(top: BorderSide(color: Colors.transparent, width: 0)),
          //   // ));
        ));
  }
}
