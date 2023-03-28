import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:istory/models/story.dart';
import 'package:istory/constants/categories.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late DatabaseReference _storiesRef;
  List<StoryModel> _stories = [];

  @override
  void initState() {
    super.initState();
    _storiesRef = FirebaseDatabase.instance.ref().child('stories');
    _fetchStories();
  }

  void _fetchStories() async {
    final databaseEvent = await _storiesRef.once();
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Catalog'),
  //     ),
  //     body: ListView.builder(
  //       itemCount: _stories.length,
  //       itemBuilder: (context, index) {
  //         final story = _stories[index];
  //         return ListTile(
  //           title: Text(story.title),
  //           subtitle: Text(story.authorPseudonym),
  //           trailing: Text(story.category),
  //           onTap: () {
  //             Navigator.pushNamed(context, '/story', arguments: story.id);
  //             // Navigator.pushNamed(
  //             //   context,
  //             //   StoryScreen.routeName,
  //             //   arguments: StoryScreenArguments(story),
  //             // );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Categories'),
      //   automaticallyImplyLeading: false, // set to false to remove back button
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildCategoryTiles(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCategoryTiles(BuildContext context) {
    return CATEGORIES.map((category) {
      return ListTile(
        leading: Icon(category.icon),
        title: Text(category.name),
        subtitle: Text(category.hashtag),
        onTap: () {
          print("category.hashtag:${category.hashtag}");
          // handle category tile tap
          Navigator.pushNamed(context, '/category',
              arguments: category.hashtag);
        },
      );
    }).toList();
  }
}
