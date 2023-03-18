import 'package:firebase_database/firebase_database.dart';

class CharacterModel {
  late String id;
  late String name;
  late String img;

  CharacterModel({
    required this.id,
    required this.name,
    required this.img,
  });

  factory CharacterModel.fromSnapshot(DataSnapshot snapshot) {
    return CharacterModel(
      id: snapshot.key!,
      name: (snapshot.value as Map)['name'],
      img: (snapshot.value as Map)['img'],
    );
  }

  factory CharacterModel.fromMap(Map<dynamic, dynamic> map) {
    return CharacterModel(
      id: map['id'],
      name: map['name'],
      img: map['img'],
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'img': img,
    };
  }
}
