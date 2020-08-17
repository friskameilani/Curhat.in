import 'package:curhatin/pages/home.dart';
import 'package:curhatin/tabRoutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final linearGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 125, 222, 157),
      Color.fromARGB(255, 25, 184, 188)
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              child: Column(children: [
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
                logInButton(),
              ])),
        ));
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      // TODO: Login to Firebase
      formState.save();
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TabRoutes(user: user)));
        // Home(user: user)));
      } catch (e) {
        print("hello");
      }
    }
  }

  Widget titleField() {
    return Column(
      children: [
        Container(
          child: Text(
            "Hello",
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w300,
                foreground: Paint()..shader = linearGradient),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
          child: Text(
            "Login first to continue",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget logInButton() {
    return RaisedButton(
      onPressed: signIn,
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
          constraints: const BoxConstraints(
              minWidth: 88.0,
              minHeight: 44.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'Log in',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
