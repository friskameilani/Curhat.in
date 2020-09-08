import 'dart:io';
// import 'dart:async';
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
import 'package:path/path.dart';
import 'package:curhatin/pages/welcome.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  File _image;
  String url;
  bool _isButtonDisabled = true;
  bool _load = true;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
      (_image != null) ? _isButtonDisabled = false : _isButtonDisabled = true;
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
                          child: (_image == null)
                              ? (userData.photoUrl == null)
                                  ? Material(
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
                              : Material(
                                  child: Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(125)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                        ),
                        Positioned(
                            bottom: -5,
                            right: 130,
                            child: Stack(
                              children: [
                                Container(
                                  height: 41,
                                  width: 41,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(125)),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    size: 25,
                                    color: Color(0xFF17B7BD).withOpacity(0.8),
                                  ),
                                  onPressed: getImage,
                                  padding: EdgeInsets.only(right: 5, bottom: 5),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.grey,
                                  iconSize: 25,
                                ),
                              ],
                            ))
                      ],
                    ),
                    ListTile(
                      title: Center(
                        child: Text('${userData.name}'),
                      ),
                      subtitle: Center(
                        child: Text('FATETA 56'),
                      ),
                    ),
                    SettingPage(),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    _isButtonDisabled
                        ? FlatButton(
                            onPressed: null,
                            textColor: Colors.grey,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                              80.0,
                            )),
                            child: const Text(
                              'Update',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : RaisedButton(
                            onPressed: () async {
                              _scaffoldKey.currentState
                                  .showSnackBar(new SnackBar(
                                content: new Row(
                                  children: <Widget>[
                                    new CircularProgressIndicator(),
                                    new Text("  Uploading...")
                                  ],
                                ),
                              ));

                              StorageReference firebaseStorageRef =
                                  FirebaseStorage.instance
                                      .ref()
                                      .child(_image.path.toString());
                              StorageUploadTask uploadTask =
                                  firebaseStorageRef.putFile(_image);
                              StorageTaskSnapshot downloadUrl =
                                  (await uploadTask.onComplete);
                              String photoUrl =
                                  (await downloadUrl.ref.getDownloadURL());
                              await DatabaseServices(uid: user.uid)
                                  .updateProfilePicture(photoUrl);

                              setState(() {
                                _isButtonDisabled = true;
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Profile Picture Uploaded')));
                                print('url : $photoUrl');
                              });
                            },
                            color: Color(0xFF17B7BD),
                            textColor: Colors.white,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                              80.0,
                            )),
                            child: const Text(
                              'Update',
                              textAlign: TextAlign.center,
                            ),
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
