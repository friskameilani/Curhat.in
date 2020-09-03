import 'package:curhatin/setup/signUp.dart';
import 'package:curhatin/setup/signIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: Color.fromRGBO(143, 238, 191, 1),
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(30, 70, 30, 0),
          child: Column(
            children: [
              Text("Curhat.in",
                style: TextStyle(fontSize: 60, fontFamily: "AdreenaScript", color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 10.0, color: Colors.black38, offset: Offset(1, 1)),
                    ]),),
              Text(
                "Ruang Konsultasi Online Berbasis\nAndroid untuk Mahasiswa IPB",
                style: TextStyle(fontSize: 18, color: Colors.white, fontStyle: FontStyle.italic, fontFamily: "OpenSans-Regular",
                    shadows: [
                      Shadow(blurRadius: 10.0, color: Colors.black38, offset: Offset(2, 2)),
                    ]),
                textAlign: TextAlign.center,),
              Padding(
                padding:EdgeInsets.fromLTRB(0, 20, 0, 20),
              ),
              Image.asset("assets/images/image-landing-page-2.png", scale: 0.9,),
              Padding(
                padding:EdgeInsets.only(bottom: 60),
              ),
              signInButton(),
              Padding(
                padding:EdgeInsets.fromLTRB(0, 15, 0, 0),
              ),
              signUpButton()
            ],
          )
      ),
  );
  }

  Widget signInButton() {
    return RaisedButton(
      onPressed: toSignIn,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      color: Color.fromRGBO(90, 189, 140, 1),
      child: Container(
        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
        // min sizes for Material buttons
        alignment: Alignment.center,
        child: const Text(
          "Sign in",
          textAlign: TextAlign.center,
        ),),
    );
  }
  Widget signUpButton() {
    return RaisedButton(
      onPressed: toSignUp,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      color: Color.fromRGBO(90, 189, 140, 1),
      child: Container(
        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
        // min sizes for Material buttons
        alignment: Alignment.center,
        child: const Text(
          "Sign up",
          textAlign: TextAlign.center,
        ),),
    );
  }

  void toSignUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
  void toSignIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

