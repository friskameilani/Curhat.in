import 'package:curhatin/models/usersChat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class CounselorDetail extends StatefulWidget {
  @override
  _CounselorDetailState createState() => _CounselorDetailState();
  final UsersChat detail;
  CounselorDetail({this.detail});
}

class _CounselorDetailState extends State<CounselorDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.detail.name}'),
        backgroundColor: Color(0xFF17B7BD),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.detail.name, style: TextStyle(fontSize: 20),),
            SizedBox(height: 30,),
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ChatPage()));
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0),),
              child: Ink(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 125, 222, 157),
                        Color.fromARGB(255, 25, 184, 188)
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(80.0),)),
                child: Container(
                  constraints: const BoxConstraints(
                      maxWidth: 100.0,
                      minHeight: 36.0), // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: const Text(
                    'Chat',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
