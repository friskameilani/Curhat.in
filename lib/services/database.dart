import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
}
