// TODO: make root page for login

// import 'package:curhatin/pages/home.dart';
// import 'package:curhatin/pages/welcome.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class RootPage extends StatefulWidget {
//   @override
//   _RootPageState createState() => _RootPageState();
// }

// enum AuthStatus { notSignedIn, signedIn }

// class _RootPageState extends State<RootPage> {
//   Future currentUser() async {
//     FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     return user;
//   }

//   AuthStatus authStatus = AuthStatus.notSignedIn;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     currentUser().then((userId) {
//       setState(() {
//         authStatus =
//             userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (authStatus) {
//       case AuthStatus.notSignedIn:
//         return WelcomePage();
//       case AuthStatus.signedIn:
//         return Home(user: user);
//     }
//   }
// }
