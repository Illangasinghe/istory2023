import 'package:firebase_database/firebase_database.dart';

class MessageModel {
  String storyId;
  String messageId;
  String characterName;
  String characterImg;
  String text;
  int timestamp;

  MessageModel({
    required this.storyId,
    required this.messageId,
    required this.characterName,
    required this.characterImg,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromSnapshot(DataSnapshot snapshot) {
    return MessageModel(
      storyId: (snapshot.value as Map)['story_id'],
      messageId: snapshot.key!,
      characterName: (snapshot.value as Map)['character_name'],
      characterImg: (snapshot.value as Map)['character_img'],
      text: (snapshot.value as Map)['text'],
      timestamp: (snapshot.value as Map)['timestamp'],
    );
  }

  factory MessageModel.fromMap(String idFromMap, Map<dynamic, dynamic> map) {
    return MessageModel(
      messageId: idFromMap,
      storyId: map['story_id'],
      characterName: map['character_name'],
      characterImg: map['character_img'],
      text: map['text'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'story_id': storyId,
      'message_id': messageId,
      'character_name': characterName,
      'character_img': characterImg,
      'text': text,
      'timestamp': timestamp,
    };
  }

  _readTimestamp(String unixTimestamp) {
    return '';
  }
}
