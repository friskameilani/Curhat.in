import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curhatin/models/usersChat.dart';
import 'package:curhatin/services/auth.dart';

class DatabaseServices {
  final String uid;

  DatabaseServices({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  final DocumentReference singleUser =
      Firestore.instance.collection('users').document();

  Future updateUserData(String name, String dept, int age) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'department': dept,
      'age': age,
      'role': 'user',
    });
  }

  //Generate chat list
  List<UsersChat> _usersChatList(QuerySnapshot querySnapshot) {
    try {
      return querySnapshot.documents.map((doc) {
        return UsersChat(
            name: doc.data['name'] ?? '',
            age: doc.data['age'] ?? 0,
            role: doc.data['role'] ?? '');
      }).toList();
    } catch (e) {
      print(e);
    }
  }

  // Stream<DocumentSnapshot> get singleUser {
  //   return userCollection.snapshots();
  // }

  Stream<List<UsersChat>> get users {
    return userCollection.snapshots().map(_usersChatList);
  }
}
