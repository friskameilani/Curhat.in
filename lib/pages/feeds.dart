import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curhatin/pages/article.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:curhatin/services/database.dart';
import 'package:provider/provider.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/pages/postArticle.dart';

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
      QuerySnapshot snap = await Firestore.instance
          .collection("feeds")
          .orderBy("date", descending: true)
          .getDocuments();
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
    final user = Provider?.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseServices(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    "Curhat.in",
                    style: TextStyle(
                        fontFamily: "AdreenaScript",
                        fontWeight: FontWeight.w800,
                        fontSize: 28),
                    textWidthBasis: TextWidthBasis.parent,
                  ),
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
                ) : Container(
                    child: ListView.builder(
                        itemCount: feeds.length,
                        itemBuilder: (context, i) {
                          return Container(
                              height: 100,
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Card(
                                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(10),
                                    leading: SizedBox(
                                      height: 125,
                                      width: 100,
                                      child: Image.network(
                                        feeds[i].data["photoUrl"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      feeds[i].data["title"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                        timeago.format(feeds[i].data["date"].toDate())
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArticlePage(detail: feeds[i]))
                                      );
                                      },
                                  ),
                                ),
                              ));
                        })),
                bottomNavigationBar: (userData.role == 'admin') ?
                Container(
                  padding: EdgeInsets.all(20),
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF17B7BD),
                    radius: 30,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostArticle(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                  )
                ) : null
            );
          } else {
            return Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
