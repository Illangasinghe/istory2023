import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String id;
  final String email;
  final String pseudonym;
  final String name;
  double rating = 0;
  int level = 0;
  final String img;
  final String bio;

  UserModel({
    required this.id,
    required this.email,
    required this.pseudonym,
    required this.name,
    required this.rating,
    required this.level,
    required this.img,
    required this.bio,
  });

  factory UserModel.fromSnapshot(DataSnapshot snapshot) {
    return UserModel(
      id: snapshot.key!,
      email: (snapshot.value as Map)['email'],
      pseudonym: (snapshot.value as Map)['pseudonym'],
      name: (snapshot.value as Map)['name'],
      rating: (snapshot.value as Map)['rating'].toDouble(),
      level: (snapshot.value as Map)['level'],
      img: (snapshot.value as Map)['img'],
      bio: (snapshot.value as Map)['bio'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['user_id'],
      email: map['email'],
      pseudonym: map['pseudonym'],
      name: map['name'],
      rating: map['rating'],
      level: map['level'],
      img: map['img'],
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'email': email,
      'pseudonym': pseudonym,
      'name': name,
      'rating': rating,
      'level': level,
      'img': img,
      'bio': bio,
    };
  }
}
