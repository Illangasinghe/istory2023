import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:istory/models/character.dart';
import 'package:istory/models/message.dart';
import 'package:istory/models/story.dart';
import 'package:istory/screens/read/story_details_screen.dart';
import 'package:istory/screens/home/home_screen.dart';
import 'package:istory/services/firebase_database.dart';
import 'package:intl/intl.dart';

class WriteStoryScreen extends StatefulWidget {
  final StoryModel story;

  WriteStoryScreen({required this.story});

  @override
  _WriteStoryScreenState createState() => _WriteStoryScreenState();
}

class _WriteStoryScreenState extends State<WriteStoryScreen> {
  late List<MessageModel> _conversationHistory;
  late String _currentCharacterId;
  late String _currentCharacterName;
  late String _currentCharacterImg;
  late TextEditingController _textEditingController;
  late List<CharacterModel> _characters;
  int _selectedCharacterIndex = 0;

  @override
  void initState() {
    super.initState();
    _conversationHistory = [];
    _characters = widget.story.characters;
    _currentCharacterId = _characters[0].id;
    _currentCharacterName = _characters[0].name;
    _currentCharacterImg = _characters[0].img;
    _textEditingController = TextEditingController();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

// ** The listen() function in Firebase Realtime Database should ideally be used when you need to receive real-time updates. */
  void _subscribeToMessages() {
    FirebaseDatabaseService()
        .getStoryMessagesReference(widget.story.id)
        .onChildAdded
        .listen(_onMessageAdded);
  }

  void _onMessageAdded(DatabaseEvent event) {
    MessageModel messageModel = MessageModel.fromSnapshot(event.snapshot);
    setState(() {
      _conversationHistory.add(messageModel);
    });
  }

  void _addMessage() {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      final message = MessageModel(
        messageId: '',
        storyId: widget.story.id,
        characterName: _currentCharacterName,
        characterImg: _currentCharacterImg,
        text: text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      FirebaseDatabaseService().addStoryMessage(widget.story.id, message);
      _textEditingController.clear();
    }
  }

  void _editMessage(int index) {
    final message = _conversationHistory[index].text;
    //set character from the _conversationHistory as well.
    _textEditingController.text = message;
    _deleteMessage(index);
  }

  void _deleteMessage(int index) {
    setState(() {
      _conversationHistory.removeAt(index);
    });
  }

  void _saveStoryAsDraft() {
    final updatedStory = widget.story.copyWith(
      lastUpdated: DateTime.now().toIso8601String(),
      // firstSender: _currentCharacterId,
      status: 'draft',
    );
    FirebaseDatabaseService().updateStory(widget.story.id, updatedStory);
    Navigator.pop(context);
  }

  Future<void> _publishStory() async {
    final updatedStory = widget.story.copyWith(
      lastUpdated: DateTime.now().toUtc().toString(),
      firstSender: _currentCharacterName,
      status: 'published',
    );
    //** When review  */
    await FirebaseDatabaseService().updateStory(
        widget.story.id, widget.story.copyWith(status: 'in-review'));
    FirebaseDatabaseService().updateStory(widget.story.id, updatedStory);
    if (!mounted) return;
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => StoryDetailsScreen(story: updatedStory),
    //   ),
    // );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Story published successfully.'),
    ));
    // Pop until home screen
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        automaticallyImplyLeading: true, // set to false to remove back button
      ),
      body: Column(
        children: <Widget>[
          _buildCharacterSelectionDropdown(),
          Flexible(
            child: ListView.builder(
              itemCount: _conversationHistory.length,
              reverse: false, // Reverse the list view
              itemBuilder: (context, index) {
                return _buildMessageItem(
                    _conversationHistory[index].text,
                    _conversationHistory[index].characterName,
                    _conversationHistory[index].characterImg);
              },
            ),
          ),
          _buildMessageComposer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: _saveStoryAsDraft,
                child: const Text('Save Draft'),
              ),
              TextButton(
                onPressed: _publishStory,
                child: const Text('Publish'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterSelectionDropdown() {
    return DropdownButton(
      value: _selectedCharacterIndex,
      items: _characters.map((CharacterModel character) {
        return DropdownMenuItem(
          value: _characters.indexOf(character),
          child: Text(character.name),
        );
      }).toList(),
      onChanged: (int? index) {
        if (index != null) {
          setState(() {
            _selectedCharacterIndex = index;
            _currentCharacterId = _characters[index].id;
            _currentCharacterImg = _characters[index].img;
            _currentCharacterName = _characters[index].name;
          });
        }
      },
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration.collapsed(
                hintText: 'Add a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _addMessage();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
      String message, String senderName, String senderImg) {
    final isSent = senderName == _currentCharacterName;

    final card = Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: isSent ? 15 : 0,
        vertical: 5,
      ),
      color: isSent ? Colors.lightBlue[100] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isSent ? Colors.lightBlue[100]! : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );

    final avatar = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(senderImg),
          fit: BoxFit.cover,
        ),
      ),
    );

    return Row(
      mainAxisAlignment:
          isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSent) avatar,
        card,
        if (isSent) avatar,
      ],
    );
  }
}
