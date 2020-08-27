import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController textEditingController = TextEditingController();
  bool isLoading;

  SharedPreferences preferences;
  var listMessage;

  @override
  void initState(){
    super.initState();
    isLoading = false;

    readLocal();
  }

  readLocal() async
  {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "Melan",
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: '\nFMIPA 54',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ]
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: MediaQuery.of(context).size.height - 220,),
            createInput()
          ],
        ),
      )
    );
  }


  createInput()
  {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child:Flexible(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF17B7BD),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
//              gradient: LinearGradient(
//                colors: [
//                  Color.fromARGB(255, 125, 222, 157),
//                  Color.fromARGB(255, 25, 184, 188)
//                ],
//              ),
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

}
