class User {
  final String uid;
  final String email;
  User({this.uid, this.email});
}

class UserData {
  final String uid;
  final String name;
  final int age;
  final String role;
  final String photoUrl;
  final String status;

  UserData({
    this.uid,
    this.name,
    this.age,
    this.role,
    this.photoUrl,
    this.status,
  });
}
