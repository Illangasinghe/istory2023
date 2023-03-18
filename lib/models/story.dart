import 'package:firebase_database/firebase_database.dart';
import 'package:istory/models/character.dart';

class StoryModel {
  late String id;
  late String title;
  late String authorId;
  late String authorPseudonym;
  late String authorImg;
  late String desc;
  late String lastUpdated;
  late String category;
  late List<CharacterModel> characters;
  late String firstSender;
  late int totalMessages;
  late int views;
  late int likes;
  late int dislikes;
  late int rating;
  late String coverImg;
  late String bgImg;
  late List<String> tags;
  late String status;

  StoryModel({
    required this.id,
    required this.title,
    required this.authorId,
    required this.authorPseudonym,
    required this.authorImg,
    required this.desc,
    required this.lastUpdated,
    required this.category,
    required this.characters,
    required this.firstSender,
    this.totalMessages = 0,
    this.views = 0,
    this.likes = 0,
    this.dislikes = 0,
    this.rating = 0,
    required this.coverImg,
    required this.bgImg,
    required this.tags,
    required this.status,
  });

  factory StoryModel.fromSnapshot(DataSnapshot snapshot) {
    return StoryModel(
      id: snapshot.key!,
      title: (snapshot.value as Map)['title'],
      authorId: (snapshot.value as Map)['author_id'],
      authorPseudonym: (snapshot.value as Map)['author_pseudonym'],
      authorImg: (snapshot.value as Map)['author_img'],
      desc: (snapshot.value as Map)['desc'],
      lastUpdated: (snapshot.value as Map)['last_updated'],
      category: (snapshot.value as Map)['category'],
      characters: (snapshot.value as Map)['characters'] == null
          ? []
          : (snapshot.value as Map)['characters']
              .map<CharacterModel>((c) => CharacterModel.fromMap(c))
              .toList(),
      firstSender: (snapshot.value as Map)['first_sender'],
      totalMessages: (snapshot.value as Map)['total_messages'],
      views: (snapshot.value as Map)['views'],
      likes: (snapshot.value as Map)['likes'],
      dislikes: (snapshot.value as Map)['dislikes'],
      rating: (snapshot.value as Map)['rating'].toDouble(),
      coverImg: (snapshot.value as Map)['cover_img'],
      bgImg: (snapshot.value as Map)['bg_img'],
      tags: List<String>.from((snapshot.value as Map)['tags'] ?? []),
      status: (snapshot.value as Map)['status'],
    );
  }

  factory StoryModel.fromMap(String idFromMap, Map<dynamic, dynamic> map) {
    return StoryModel(
      id: idFromMap,
      characters: (map['characters'] as List<dynamic>)
          .map((c) => CharacterModel.fromMap(c as Map<dynamic, dynamic>))
          .toList(),
      title: map['title'] as String,
      authorId: map['author_id'] as String,
      authorPseudonym: map['author_pseudonym'] as String,
      authorImg: map['author_img'] as String,
      desc: map['desc'] as String,
      lastUpdated: map['last_updated'] as String,
      category: map['category'] as String,
      firstSender: map['first_sender'] as String,
      totalMessages: map['total_messages'] as int,
      views: map['views'] as int,
      likes: map['likes'] as int,
      dislikes: map['dislikes'] as int,
      rating: map['rating'] as int,
      coverImg: map['cover_img'] as String,
      bgImg: map['bg_img'] as String,
      tags: (map['tags'] as List<dynamic>).cast<String>(),
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author_id': authorId,
      'author_pseudonym': authorPseudonym,
      'author_img': authorImg,
      'desc': desc,
      'last_updated': lastUpdated,
      'category': category,
      'characters': characters.map((c) => c.toMap()).toList(),
      'first_sender': firstSender,
      'total_messages': totalMessages,
      'views': views,
      'likes': likes,
      'dislikes': dislikes,
      'rating': rating,
      'cover_img': coverImg,
      'bg_img': bgImg,
      'tags': tags,
      'status': status,
    };
  }

  StoryModel copyWith({
    String? id,
    String? title,
    String? desc,
    String? lastUpdated,
    String? category,
    List<CharacterModel>? characters,
    String? firstSender,
    String? coverImg,
    String? bgImg,
    List<String>? tags,
    String? authorId,
    String? authorPseudonym,
    String? authorImg,
    String? status,
  }) {
    return StoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      category: category ?? this.category,
      characters: characters ?? this.characters,
      firstSender: firstSender ?? this.firstSender,
      coverImg: coverImg ?? this.coverImg,
      bgImg: bgImg ?? this.bgImg,
      tags: tags ?? this.tags,
      authorId: authorId ?? this.authorId,
      authorPseudonym: authorPseudonym ?? this.authorPseudonym,
      authorImg: authorImg ?? this.authorImg,
      status: status ?? this.status,
    );
  }
}
