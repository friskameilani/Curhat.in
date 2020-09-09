import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _nameInputController = TextEditingController();
  var _departmentInputController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  File _image;
  String photoUrl;
  String name;
  String department;
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

  @override
  Widget build(BuildContext context) {
    final user = Provider?.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseServices(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    "Edit Profile",
                  ),
                  backgroundColor: Color(0xFF17B7BD),
                ),
                body: Column(
                  children: [
                    SizedBox(height: 20,),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: (_image == null)?
                          (userData.photoUrl == null)?
                          Material(
                            child: Image.network(
                              "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(125)
                            ),
                            clipBehavior: Clip.hardEdge,
                          ) : Material(
                            child: Image.network(
                              '${userData.photoUrl}',
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(125)
                            ),
                            clipBehavior: Clip.hardEdge,
                          ) : Material(
                            child: Image.file(
                              _image,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(125)
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                        ),
                        Positioned(
                            right: 120,
                            top: 50,
                            child: Stack(
                              children: [
                                Container(
                                  height: 41,
                                  width: 41,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(125)
                                    ),
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
                            )
                        )
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                            child: TextField(
                              controller: _nameInputController,
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  hintText: "${userData.name}",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextField(
                              controller: _departmentInputController,
                              decoration: InputDecoration(
                                  labelText: "Department",
                                  hintText: (userData.department != null)?
                                  "${userData.department}" : "IPB",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                    RaisedButton(
                      onPressed: () async {
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: new Row(
                            children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("  Uploading...")
                            ],
                          ),
                        ));

                        (_nameInputController == null) ?
                        name = userData.name : name = _nameInputController.text;

                        (_departmentInputController == null) ?
                        department = userData.department : department = _departmentInputController.text;

                        if(_image != null) {
                          StorageReference firebaseStorageRef =
                          FirebaseStorage.instance
                              .ref()
                              .child(_image.path.toString());
                          StorageUploadTask uploadTask = firebaseStorageRef
                              .putFile(_image);
                          StorageTaskSnapshot downloadUrl = (await uploadTask
                              .onComplete);
                          photoUrl = (await downloadUrl.ref
                              .getDownloadURL());
                        } else {
                          photoUrl = userData.photoUrl;
                        }
                        await DatabaseServices(uid: user.uid)
                            .updateProfilePicture(photoUrl, name, department);

                        setState(() {
                          _isButtonDisabled = true;
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Profile Updated')));
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
                  ],
                )
            );
          } else {
            return Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            );
          }
        }
        );
  }
}
