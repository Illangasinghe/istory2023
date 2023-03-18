import 'package:firebase_database/firebase_database.dart';

class ReviewModel {
  late String id;
  late String userId;
  late int rating;
  late String comment;
  late String timestamp;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  ReviewModel.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key!,
        userId = (snapshot.value as Map)['user_id'],
        rating = (snapshot.value as Map)['rating'],
        comment = (snapshot.value as Map)['comment'],
        timestamp = (snapshot.value as Map)['timestamp'];

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}
