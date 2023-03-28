import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:istory/models/story.dart';
import 'package:istory/constants/categories.dart';

class CategoryScreen extends StatefulWidget {
  final String? categoryHashtag;

  CategoryScreen({this.categoryHashtag});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late DatabaseReference _storiesRef;
  List<StoryModel> _stories = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    _storiesRef = databaseReference.child('stories');
    _fetchStories();
  }

  void _fetchStories() async {
    final databaseEvent = await _storiesRef.once();
    final stories = <StoryModel>[];
    final storiesMap = databaseEvent.snapshot.value as Map<dynamic, dynamic>?;
    if (storiesMap != null) {
      storiesMap.forEach((key, value) {
        final story = StoryModel.fromMap(key, value as Map<dynamic, dynamic>);
        if (story.status == 'published' &&
            story.category == widget.categoryHashtag) {
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
    final category = CATEGORIES
        .firstWhere((category) => category.hashtag == widget.categoryHashtag);
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} (${category.hashtag})'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.book),
                  const SizedBox(width: 8.0),
                  Text(
                    category.hashtag,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                category.description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                final story = _stories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(story.title),
                        subtitle: Text(story.authorPseudonym),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/read-story',
                            arguments: {'storyId': story.id},
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
