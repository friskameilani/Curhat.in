import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curhatin/models/article.dart';
import 'package:provider/provider.dart';
import 'package:curhatin/services/database.dart';
import 'package:intl/intl.dart';
import 'package:curhatin/pages/article.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isLoading = true;
  List<DocumentSnapshot> feeds;

  @override
  void initState() {
    _fetchPosts();
    super.initState();
  }

  _fetchPosts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot snap = await Firestore.instance.collection("feeds").orderBy("date", descending: true).getDocuments();
      setState(() {
        feeds = snap.documents;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Curhat.in",
              style: TextStyle(
                  fontFamily: "AdreenaScript",
                  fontWeight: FontWeight.w800,
                  fontSize: 28),
              textWidthBasis: TextWidthBasis.parent,),
            backgroundColor: Color(0xFF17B7BD),
          ),
          body: (_isLoading)?
          Center(
            child: Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            )
          )
    : Container(
            child: ListView.builder(
              itemCount: feeds.length,
              itemBuilder: (context, i) {
                return Container(
                  height: 120,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(20),
                          leading: SizedBox(
                            height: 125,
                            width: 100,
                            child: Image.network(feeds[i].data["photoUrl"], fit: BoxFit.cover,),
                          ),
                          title: Text(
                            feeds[i].data["title"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          ////// MASIH BINGUNG CARA UBAH FORMAT :"
                          subtitle: Text(feeds[i].data["date"].toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArticlePage(
                                        detail: feeds[i])));
                          },
                        ),
                      ),
                    ));
                })));

////// INI KALO MAU BENTUKNYA KAYAK FEEDS IG //////////

//                return InkWell(
//                    onTap: () {
//                      Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => ArticlePage(
//                                    detail: feeds[i])));
//                    },
//                    child: Container(
//                      decoration: BoxDecoration(
//                          color: Colors.white,
//                          borderRadius: BorderRadius.circular(8),
//                          boxShadow: [
//                            BoxShadow(
//                              blurRadius: 6,
//                              color: Color(0x22000000),
//                              offset: Offset(0,4),
//                            ),
//                          ]
//                      ),
//                      padding: EdgeInsets.symmetric(
//                        horizontal: 10,
//                        vertical: 10,
//                      ),
//                      margin: EdgeInsets.symmetric(
//                        horizontal: 10,
//                        vertical: 5,
//                      ),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
////                          Text(feeds[i].data["uploadedBy"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
////                          SizedBox(height: 5,),
//                          Center(
//                            child: Image.network(feeds[i].data["photoUrl"], height: 220),
//                          ),
//                          SizedBox(height: 5,),
//                          RichText(
//                            softWrap: true,
//                            maxLines: 2,
//                            overflow: TextOverflow.ellipsis,
//                            text: TextSpan(
//                                style: TextStyle(
//                                  color: Colors.black,
//                                ),
//                                children: [
//                                  TextSpan(
//                                    text: feeds[i].data["uploadedBy"],
//                                    style: TextStyle(
//                                      fontWeight: FontWeight.bold,
//                                    ),
//                                  ),
//                                  TextSpan(
//                                    text: " ${feeds[i].data["content"]}",
//                                  ),
//                                ]
//                            ),
//                          ),
//                        ],
//                      ),
//                    )
//                );
//              },))
//      );
//    }
  }
}