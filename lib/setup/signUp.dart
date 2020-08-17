import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curhatin/setup/signIn.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final linearGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 125, 222, 157),
      Color.fromARGB(255, 25, 184, 188)
    ],
  ).createShader(Rect.fromLTWH(200.0, 50.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                titleField(),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please type an email';
                    }
                  },
                  onSaved: (input) => _email = input,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Your password needs to be at least 6 characters';
                    }
                  },
                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                ),
                signUpButton(),
              ],
            ),
          ),
        ));
  }

  Widget titleField() {
    return Container(
      alignment: Alignment.topRight,
      child: Text(
        "Sign up",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.w300,
          foreground: Paint()..shader = linearGradient,
        ),
      ),
    );
  }

  Widget signUpButton() {
    return RaisedButton(
      onPressed: signUp,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      child: Ink(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 125, 222, 157),
                Color.fromARGB(255, 25, 184, 188)
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(80.0))),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 44.0),
          // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'Sign up',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: _email, password: _password))
            .user;
        CollectionReference usercollection =
            (await Firestore.instance.collection('users'));
        await usercollection.document(user.uid).setData({
          'name': user.email,
          'age': 20,
          'hobby': 'none',
          'role': 'user',
        });
        user.sendEmailVerification();
        Navigator.of(context).pop();
      } catch (e) {
        print("hello");
      }
    }
  }

  void toSignIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
