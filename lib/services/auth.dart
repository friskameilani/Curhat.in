import 'package:curhatin/models/user.dart';
import 'package:curhatin/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Returns a simplified instance of a user
  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  // auth changed user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebase(user));
  }
  // Stream<FirebaseUser> get user {
  //   return _auth.onAuthStateChanged;
  // }

  Future signInWithEmailPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e);
    }
  }

  Future registerWithEmailPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      var split = email.split('@');
      String name = split[0];
      var uid = user.uid;

      //create new document for the user with uid
      await DatabaseServices(uid: user.uid)
          .updateUserData(uid, name, 'IPB', 20);
      return _userFromFirebase(user);
    } catch (e) {
      print(e);
    }
  }

  // Future signInAnon() async {
  //   try {
  //     AuthResult result = await _auth.signInAnonymously();
  //     FirebaseUser user = result.user;
  //     return _userFromFirebase(user);
  //     // return user;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
