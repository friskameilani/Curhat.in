import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/article.dart';
import 'package:curhatin/pages/feeds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
  final DocumentSnapshot detail;
  ArticlePage({this.detail});
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.detail.data['title']}'),
          backgroundColor: Color(0xFF17B7BD),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(widget.detail.data['photoUrl'], height: 250,),
                ),
                Text("By: ${widget.detail.data['uploadedBy']}", style: TextStyle(color: Colors.grey),),
                SizedBox(height: 20,),
                Text(widget.detail.data['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                SizedBox(height: 10,),
                Text(widget.detail.data['content'], textAlign: TextAlign.justify,)
              ],
            ),
          )
        )
    );
  }
}
