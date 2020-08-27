import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:curhatin/root.dart';
import 'package:curhatin/services/auth.dart';
import 'package:curhatin/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:curhatin/components/setting.dart';
import 'package:curhatin/components/themeApp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:curhatin/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage({ this.user });
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  SharedPreferences preferences;
  String newPhotoUrl;
  File imageFileAvatar;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    File newImageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      this.imageFileAvatar = newImageFile;
    });
    
    uploadPic();
  }

  Future uploadPic() async{
    String fileName = basename(imageFileAvatar.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFileAvatar);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    setState(() {
      this.newPhotoUrl = fileName;
    });
  }
//  Future<Null> logOutButton() async {
//    // await FirebaseAuth.instance.signOut();
//    await auth.signOut();
//
//    this.setState(() {
//      isLoading = false;
//    });
//
//    Navigator.of(context).pushAndRemoveUntil(
//        MaterialPageRoute(builder: (context) => RootPage()),
//            (Route<dynamic> route) => false);
//  }


  Widget build(BuildContext context) {
   final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseServices(uid: user.uid).userData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          userData.photoUrl = newPhotoUrl;
          print(userData.photoUrl);
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
                              ? (userData.photoUrl != null)
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
                                imageUrl: userData.photoUrl,
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
                              this.imageFileAvatar,
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
                FlatButton(
                  onPressed: () async {
                    await DatabaseServices(uid: user.uid).updateProfilePicture(
                        userData.photoUrl ?? snapshot.data.photoUrl,
                    );
                  },
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
                    onPressed: () async {
                      await _auth.signOut();

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => RootPage()),
                            (Route<dynamic> route) => false);
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
          return Text ("no data");
          }
        }
    );
  }
}
