import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Email sent!"),
      content: Text("We sent an email to ${_email}."),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "We will mail you a link. Please click on that link to reset your password.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Theme(
                data: ThemeData(hintColor: Colors.black54),
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 30),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter your email";
                      } else {
                        _email = value;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                ),
              ),
              RaisedButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _email)
                        .then((value) => print("Check your mails"));
                    showAlertDialog(context);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
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
                      'Send Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
