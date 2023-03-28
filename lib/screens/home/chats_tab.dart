import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:istory/models/story.dart';

class StoryListScreen extends StatefulWidget {
  final DatabaseReference databaseReference;

  StoryListScreen({required this.databaseReference});

  @override
  _StoryListScreenState createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  late List<String> _storyIds = [];
  List<StoryModel> _stories = [];
  late DatabaseReference _storyListReference;

  @override
  void initState() {
    super.initState();
    _storyListReference = widget.databaseReference.child('stories');
    _fetchStories();
    // _loadPublishedStories();
    // _storyListReference.onValue.listen(_onStoryListUpdated);
  }

  // void _loadPublishedStories() {
  //   _storyListReference
  //       .orderByChild('status')
  //       .equalTo('published')
  //       .once()
  //       .then((DataSnapshot snapshot) {
  //         List<String> storyIds = [];
  //         if (snapshot.value != null) {
  //           Map<dynamic, dynamic> stories = snapshot.value as Map;
  //           stories.forEach((key, value) {
  //             storyIds.add(key);
  //           });
  //         }
  //         setState(() {
  //           _storyIds = storyIds;
  //         });
  //       } as FutureOr Function(DatabaseEvent value));
  // }

  // void _loadStories() async {
  //   // final databaseReference = FirebaseDatabase.instance.ref();
  //   final databaseEvent = await _storyListReference
  //       .orderByChild('status')
  //       .equalTo('published')
  //       .once();
  //   if (databaseEvent.snapshot.value != null) {
  //     final StoryModel userModel =
  //         StoryModel.fromSnapshot(databaseEvent.snapshot.children.first);
  //     setState(() {
  //       _userModel = userModel;
  //     });
  //   }
  // }

  void _fetchStories() async {
    final databaseEvent = await _storyListReference.once();
    final stories = <StoryModel>[];
    final storiesMap = databaseEvent.snapshot.value as Map<dynamic, dynamic>?;
    if (storiesMap != null) {
      storiesMap.forEach((key, value) {
        final story = StoryModel.fromMap(key, value as Map<dynamic, dynamic>);
        if (story.status == 'published') {
          stories.add(story);
        }
      });
    }
    setState(() {
      _stories = stories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Chats'),
      //     automaticallyImplyLeading: false, // set to false to remove back button
      //   ),
      body: ListView.builder(
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return ListTile(
            title: Text(story.title),
            subtitle: Text(story.authorPseudonym),
            trailing: Text(story.category),
            onTap: () {
              Navigator.pushNamed(context, '/story', arguments: story);
              // Navigator.pushNamed(
              //   context,
              //   StoryScreen.routeName,
              //   arguments: StoryScreenArguments(story),
              // );
            },
          );
        },
      ),
    );
  }
}

class StoryScreen extends StatelessWidget {
  final String appTitle;
  final DatabaseReference databaseReference;
  final String storyId;

  StoryScreen({
    required this.appTitle,
    required this.databaseReference,
    required this.storyId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        automaticallyImplyLeading: false, // set to false to remove back button
      ),
      body: Center(
        child: Text('Story: $storyId'),
      ),
    );
  }
}
