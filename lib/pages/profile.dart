import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:curhatin/root.dart';
import 'package:curhatin/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:curhatin/components/setting.dart';
import 'package:curhatin/components/themeApp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService auth = AuthService();
  SharedPreferences preferences;
  String id = "";
  String name = "";
  String about = "";
  String photoUrl = "";
  File imageFileAvatar;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    readDataFromLocal();
  }

  void readDataFromLocal() async {
    preferences = await SharedPreferences.getInstance();

    id = preferences.getString("id");
    name = preferences.getString("name");
    about = preferences.getString("about");
    photoUrl = preferences.getString("photoUrl");

    setState(() {});
  }

  Future getImage() async {
    File newImageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (newImageFile != null) {
      setState(() {
        this.imageFileAvatar = newImageFile;
        isLoading = true;
      });
    }

    uploadImageToFirestoreAndStorage();
  }

  Future uploadImageToFirestoreAndStorage() async {
    String mFileName = id;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(mFileName);
    StorageUploadTask storageUploadTask =
        storageReference.putFile(imageFileAvatar);
    StorageTaskSnapshot storageTaskSnapshot;
    storageUploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl) {
          photoUrl = newImageDownloadUrl;

          Firestore.instance.collection("users").document(id).updateData({
            "photoUrl": photoUrl,
          }).then((data) async {
            await preferences.setString("photoUrl", photoUrl);

            setState(() {
              isLoading = false;
            });

            Fluttertoast.showToast(msg: "Updated Succesfully");
          });
        }, onError: (errorMsg) {
          setState(() {
            isLoading = false;
          });

          Fluttertoast.showToast(msg: "Error occured in getting photoUrl");
        });
      }
    }, onError: (errorMsg) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: errorMsg.toString());
    });
  }

  void updateData() {
    setState(() {
      isLoading = false;
    });

    Firestore.instance.collection("users").document(id).updateData({
      "photoUrl": photoUrl,
    }).then((data) async {
      await preferences.setString("photoUrl", photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Updated Succesfully");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              ThemeApp(),
              // ini belum bisa save foto nya
              Positioned(
                bottom: 0,
                child: Stack(
                  children: <Widget>[
                    (imageFileAvatar == null)
                        ? (photoUrl != null)
                            ? Material(
                                child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.lightBlueAccent),
                                          ),
                                          width: 100,
                                          height: 100,
                                          padding: EdgeInsets.all(20),
                                        ),
                                    imageUrl: photoUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(125)),
                                clipBehavior: Clip.hardEdge,
                              )
                            : Positioned(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(125)),
                                  ),
                                ),
                              )
                        : Material(
                            child: Image.file(
                              imageFileAvatar,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(125)),
                            clipBehavior: Clip.hardEdge,
                          ),
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.white54.withOpacity(0.3),
                      ),
                      onPressed: getImage,
                      padding: EdgeInsets.all(0),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.grey,
                      iconSize: 100,
                    )
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            title: Center(
              child: Text('Mba Jago'),
            ),
            subtitle: Center(
              child: Text('FATETA 56'),
            ),
          ),
          SettingPage(),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          FlatButton(
            onPressed: updateData,
            textColor: Colors.grey,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0)),
            child: const Text(
              'Update',
              textAlign: TextAlign.center,
            ),
          ),
          OutlineButton(
              onPressed: logOutButton,
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
  }

  Future<Null> logOutButton() async {
    // await FirebaseAuth.instance.signOut();
    await auth.signOut();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RootPage()),
        (Route<dynamic> route) => false);
  }
}
