import 'package:curhatin/models/usersChat.dart';
import 'package:flutter/material.dart';

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
      ),
      body: Text(widget.detail.name),
    );
  }
}
