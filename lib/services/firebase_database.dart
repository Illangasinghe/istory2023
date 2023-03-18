import 'package:firebase_database/firebase_database.dart';
import 'package:istory/models/story.dart';
import 'package:istory/models/message.dart';

class FirebaseDatabaseService {
  final DatabaseReference _storyRef =
      FirebaseDatabase.instance.ref().child('stories');
  final DatabaseReference _messageRef =
      FirebaseDatabase.instance.ref().child('messages');

  Future<String> addStory(StoryModel story) async {
    final newStoryRef = _storyRef.push();
    await newStoryRef.set(story.toMap());
    return newStoryRef.key!;
  }

  Future<void> updateStory(String id, StoryModel updatedStory) async {
    final storyRef = _storyRef.child(id);
    await storyRef.update(updatedStory.toMap());
  }

  DatabaseReference getStoryMessagesReference(String storyId) {
    return _messageRef.child(storyId);
  }

  Future<void> addStoryMessage(String storyId, MessageModel message) async {
    final storyMessageRef = getStoryMessagesReference(storyId);
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString()
      ..substring(5); // get the current timestamp
    await storyMessageRef
        .child(timestamp)
        .set(message.toMap()); // set the message data under the timestamp key
    final storyRef = _storyRef.child(storyId);
    await storyRef.update({'total_messages': ServerValue.increment(1)});
  }

  Stream<List<StoryModel>> get stories {
    return _storyRef.onValue.map((event) {
      final stories = <StoryModel>[];
      final storiesMap = (event.snapshot.value as Map?) ?? {};

      storiesMap.forEach((storyId, storyData) {
        final story = StoryModel.fromMap(storyId, storyData);
        stories.add(story);
      });

      return stories;
    });
  }

  // Stream<List<MessageModel>> getStoryMessages(String storyId) {
  //   final storyMessageRef = getStoryMessagesReference(storyId);
  //   return storyMessageRef.onValue.map((event) {
  //     final messages = <MessageModel>[];
  //     final messagesMap = (event.snapshot.value as Map?) ?? {};

  //     messagesMap.forEach((messageId, messageData) {
  //       final message = MessageModel.fromMap(messageData);
  //       messages.add(message);
  //     });

  //     return messages;
  //   });
  // }

//   Future<List<MessageModel>> getStoryMessagesOnce(String storyId) async {
//   final storyMessageRef = getStoryMessagesReference(storyId);
//   final snapshot = await storyMessageRef.once();
//   final messages = <MessageModel>[];
//   final messagesMap = (snapshot.value as Map?) ?? {};

//   messagesMap.forEach((messageId, messageData) {
//     final message = MessageModel.fromMap(messageData);
//     messages.add(message);
//   });

//   return messages;
// }

  Future<void> deleteStory(String id) async {
    final storyRef = _storyRef.child(id);
    await storyRef.remove();
  }
}
