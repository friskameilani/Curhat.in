import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

//ini belum ke halaman chat awal tea, baru yang langsung ke isi chat nya

class ChatPage extends StatefulWidget {
//  final String receiverId;
//  final String receiverAvatar;
//  final String receiverName;
//
//  Chat({
//    Key key,
//    @required this.receiverId,
//    @required this.receiverAvatar,
//    @required this.receiverName,
//  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
//  final colorTheme = LinearGradient(
//      begin: Alignment.bottomLeft,
//      end: Alignment.topRight,
//      colors: [
//        Color(0xFF8FEEBF),
//        Color(0xFF17B7BD),
//      ]
//  );

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isLoading;

  String chatId;
  SharedPreferences preferences;
  String id;
  var listMessage;

  @override
  void initState(){
    super.initState();
    isLoading = false;

    chatId = "";
    readLocal();
  }

  readLocal() async
  {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id") ?? "";

    //mesti inisiasi pas sign in dulu, lieur
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text("Alifah", style: TextStyle(color: Colors.black,)),
//        centerTitle: true,
      ),
      body: WillPopScope(
        child: Stack(
          children: [
            Column(
              children: [
                createListMessages(),
                createInput()
              ],
            )
          ],
        ),
      ),
    );
  }

  createListMessages()
  {
    return Flexible(
      child: chatId == ""
      ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
        ),
      )
      // padahal mah belum ada apa2 :" wkwkwkk
      : StreamBuilder(
        stream: Firestore.instance.collection("messages")
            .document(chatId)
            .collection(chatId)
            .snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData)
          {
            return Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                ),
            );
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10),
//              itemBuilder: (context, index) => createItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
//              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  createInput()
  {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child:Flexible(
        child: Container(
          decoration: BoxDecoration(
            // ini biarin dulu aja pls pake gradient, suka warna nya walopun gonjreng
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 125, 222, 157),
                  Color.fromARGB(255, 25, 184, 188)
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(80.0))
          ),
          child: TextField(
            decoration: new InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.more_vert),
                  color: Colors.white,
                  onPressed: () => null,
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
            focusNode: focusNode,
          ),
        ),
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.transparent,
            width: 0
          )
        ),
      ),
    );
  }

  onSendMessage(String contentMsg, int type){

  }

}
