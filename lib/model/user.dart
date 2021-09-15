import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String photoUrl;
  final String displayName;

  User({
    required this.id,
    required this.email,
    required this.photoUrl,
    required this.displayName,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
    );
  }
}
