import 'dart:io';
import 'dart:ui';
import 'package:curhatin/services/auth.dart';
import 'package:curhatin/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:curhatin/components/setting.dart';
import 'package:curhatin/components/themeApp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:curhatin/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:curhatin/pages/welcome.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _image;
  String url;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Widget build(BuildContext context) {
    final user = Provider?.of<User>(context);
    if (user != null) {
      return StreamBuilder<UserData>(
          stream: DatabaseServices(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return Scaffold(
                key: _scaffoldKey,
                body: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ThemeApp(),
                        Positioned(
                          bottom: 0,
                          child: (userData.photoUrl == null) ?
                          Material(
                            child: Image.network(
                              "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(125)),
                            clipBehavior: Clip.hardEdge,
                          )
                        : Material(
                            child: Image.network(
                              '${userData.photoUrl}',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(125)),
                            clipBehavior: Clip.hardEdge,
                          )
                        ),
                      ],
                    ),
                    ListTile(
                      title: Center(
                        child: Text('${userData.name}'),
                      ),
                      subtitle: Center(
                        child: Text('${userData.department}'),
                      ),
                    ),
                    SettingPage(),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    OutlineButton(
                        onPressed: () async {
                          try {
                            print(user.uid);
                            DatabaseServices(uid: user.uid).makeUserOffline();
                            // await _auth.signOut();

                            print('this happened');
                            await FirebaseAuth.instance.signOut().then(
                                (value) => Navigator.of(context)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WelcomePage()),
                                        (Route<dynamic> route) => false));
                          } catch (e) {
                            print('this is the error');
                            print(e);
                          }
                        },
                        textColor: Colors.grey,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: const Text(
                            'LOG OUT',
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ],
                ),
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
    } else {
      return Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        child: CircularProgressIndicator(),
      );
    }
  }
}
