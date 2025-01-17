import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/user.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/models/article.dart';

class DatabaseServices {
  final String uid;
  final String type;

  DatabaseServices({this.uid, this.type = 'User'});

  // get Firestore collection
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  //get Admin
  final Query adminCollection =
      Firestore.instance.collection('users').where('role', isEqualTo: 'admin');

  //get Types
  Query roleCollections() {
    return Firestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .where('type', isEqualTo: this.type);
  }

  // Create and update user data to firestore
  Future updateUserData(String uid, String name, String dept, int age) async {
    return await userCollection.document(uid).setData({
      'uid': uid,
      'name': name,
      'department': dept,
      'age': age,
      'role': 'user',
      'status': 'online',
      'isChattingWith': []
    });
  }

  Future makeUserOnline() async {
    return await userCollection.document(uid).updateData({'status': 'online'});
  }

  Future makeUserOffline() async {
    return await userCollection.document(uid).updateData({'status': 'offline'});
  }

  Future updateStatus(String uid) async {
    return await userCollection.document(uid).setData({
      'status': 'online',
    });
  }

  //Map Users's Chat data to model
  List<UsersChat> _usersChatList(QuerySnapshot querySnapshot) {
    try {
      return querySnapshot.documents.map((doc) {
        return UsersChat(
          uid: doc.data['uid'] ?? '',
          name: doc.data['name'] ?? '',
          age: doc.data['age'] ?? 0,
          role: doc.data['role'] ?? '',
          type: doc.data['type'] ?? '',
          status: doc.data['status'] ?? '',
        );
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Map User data to Model
  UserData _userDataSnapshot(DocumentSnapshot snapshot) {
    try {
      return UserData(
          uid: uid,
          name: snapshot.data['name'],
          age: snapshot.data['age'],
          role: snapshot.data['role'],
          photoUrl: snapshot.data['photoUrl']);
    } catch (e) {
      print(e);
      return null;
    }
  }

  //Get All Users
  // Stream<List<UsersChat>> get users {
  //   return adminCollection.snapshots().map(_usersChatList);
  // }

  Stream<List<UsersChat>> get users {
    return roleCollections().snapshots().map(_usersChatList);
  }

  //Get current user data
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataSnapshot);
  }

  Future updateProfilePicture(String photoUrl, String name, String department) async {
    return await userCollection.document(uid).updateData({
      'photoUrl': photoUrl,
      'name' : name,
      'department' : department
    });
  }
}
