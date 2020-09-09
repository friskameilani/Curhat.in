import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PostArticle extends StatefulWidget {
  @override
  _PostArticleState createState() => _PostArticleState();
}

class _PostArticleState extends State<PostArticle> {
  File _image;
  TextEditingController _contentInputController = TextEditingController();
  TextEditingController _titleInputController = TextEditingController();
  bool _isUploading = false;
  bool _isUploadCompleted = false;
  double _uploadProgress = 0;

  // firebase

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  pickFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  pickFromPhone() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  uploadImage() async {
    try {
      if (_image != null) {
        setState(() {
          _isUploading = true;
          _uploadProgress = 0;
        });

        FirebaseUser user = await _auth.currentUser();

        String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
            basename(_image.path);

        final StorageReference storageReference =
        _storage.ref().child("feeds").child(user.uid).child(fileName);

        final StorageUploadTask uploadTask = storageReference.putFile(_image);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
          var totalBytes = event.snapshot.totalByteCount;
          var transferred = event.snapshot.bytesTransferred;
          double progress = ((transferred * 100) / totalBytes) / 100;

          setState(() {
            _uploadProgress = progress;
          });
        });

        StorageTaskSnapshot onComplete = await uploadTask.onComplete;

        String photoUrl = await onComplete.ref.getDownloadURL();

        _db.collection("feeds").add({
          "photoUrl": photoUrl,
          "title": _titleInputController.text,
          "content": _contentInputController.text,
          "date": DateTime.now().millisecondsSinceEpoch,
          "uploadedBy": user.email
        });

        // when completed
        setState(() {
          _isUploading = false;
          _isUploadCompleted = true;
        });

        streamSubscription.cancel();
        Navigator.pop(this.context);

      } else {
        showDialog(
            context: this.context,
            builder: (ctx) {
              return AlertDialog(
                content: Text("Please select image!"),
                title: Text("Alert"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              );
            });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Post"),
        backgroundColor: Color(0xFF17B7BD),
        actions: <Widget>[
          IconButton(
            tooltip: "Take from camera",
            icon: Icon(Icons.add_a_photo),
            onPressed: () {
              pickFromCamera();
            },
          ),
          IconButton(
            tooltip: "Select from phone",
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {
              pickFromPhone();
            },
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _image != null
                  ? Image.file(_image)
                  : Image(
                image: AssetImage("assets/images/upload-image.png"),
              ),
              (_isUploading)?
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: Colors.grey,
              ) : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextField(
                  controller: _titleInputController,
                  decoration: InputDecoration(
                      labelText: "Write Title here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 350
                  ),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _contentInputController,
                    decoration: InputDecoration(
                      labelText: "Write Caption here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                )
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: uploadImage,
                color: Color(0xFF17B7BD),
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      80.0,
                    )),
                child: const Text(
                  'Post',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}