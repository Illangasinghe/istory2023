import 'package:flutter/material.dart';
import 'package:istory/screens/home/chats_tab.dart';
import 'package:istory/screens/home/catalog_tab.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:istory/screens/user/profile_screen.dart';
import 'package:istory/screens/write/create_story_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // default selected tab index is 1 for StoryList

  final List<Widget> _children = [
    const CatalogScreen(),
    StoryListScreen(
      databaseReference: FirebaseDatabase.instance.ref(),
    ),
    const ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('#istory Sinhala'),
        automaticallyImplyLeading: false, // set to false to remove back button
        elevation: 0.1,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to profile/settings screen
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-story');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message_rounded,
            ),
            label: 'Stories',
          ),
          // /**3rd tab: Questions (Will only have the icon. Does not include in the MVP) */
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.handshake_outlined, color: Colors.blue),
          //   label: 'Questions',
          // ),
          // /**4th tab: Reviews (Will only have the icon. Does not include in the MVP) */
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.feedback_outlined, color: Colors.blue),
          //   label: 'Reviews',
          // ),
          // /**5th tab: News (Will only have the icon. Does not include in the MVP) */
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.fiber_manual_record_outlined, color: Colors.blue),
          //   label: 'News',
          // ),
          /** Settings (Will only have the icon. Does not include in the MVP) */
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
