import 'package:flutter/material.dart';
import 'package:istory/models/character.dart';
import 'package:istory/models/message.dart';
import 'package:istory/models/story.dart';
import 'package:istory/screens/read/story_details_screen.dart';
import 'package:istory/screens/home/home_screen.dart';
import 'package:istory/services/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import 'dart:async';
import 'dart:math';

import 'package:intl/intl.dart';

class ReadStoryScreen extends StatefulWidget {
  final StoryModel story;

  const ReadStoryScreen({required this.story});

  @override
  _ReadStoryScreenState createState() => _ReadStoryScreenState();
}

class _ReadStoryScreenState extends State<ReadStoryScreen> {
  List<MessageModel> _messages = [];
  int _currentMessageIndex = 0;
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  WidgetsBinding? _widgetsBinding;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _widgetsBinding = WidgetsBinding.instance;
  }

  void _showNextMessage() {
    if (_currentMessageIndex < _messages.length - 1) {
      setState(() {
        _currentMessageIndex++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End of conversation')),
      );
    }
    _textEditingController.clear();
  }

  Future<void> _loadMessages() async {
    final dbRef = FirebaseDatabase.instance.ref();
    final dbEvent = await dbRef
        .child('messages')
        .child(widget.story.id)
        .orderByKey()
        .once();
    final Map<dynamic, dynamic>? messagesMap =
        dbEvent.snapshot.value as Map<dynamic, dynamic>?;
    final List<MessageModel> loadedMessages = [];
    if (messagesMap != null) {
      final sortedKeys = messagesMap.keys.toList()..sort();
      for (var key in sortedKeys) {
        final value = messagesMap[key];
        final message =
            MessageModel.fromMap(key, value as Map<dynamic, dynamic>);
        loadedMessages.add(message);
      }
    }
    setState(() {
      _messages = loadedMessages;
    });
  }

  @override
  Widget build(BuildContext context) {
    _widgetsBinding?.addPostFrameCallback((_) {
      _scrollToBottomAfterBuild();
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0, //
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.story.coverImg),
            ),
            const SizedBox(width: 4),
            Text(widget.story.title),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[index];
                final isRightAligned =
                    message.characterName == widget.story.firstSender;
                if (index == 0) {
                  return _buildMessageWidget(message, isRightAligned);
                }
                if (index <= _currentMessageIndex) {
                  return GestureDetector(
                    onTap: _showNextMessage,
                    child: _buildMessageWidget(message, isRightAligned),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: 3, // allow an unlimited number of lines
                  keyboardType: TextInputType
                      .multiline, // set the keyboard type to multiline
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Add a message...',
                  ),
                  controller: _textEditingController,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _showNextMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(MessageModel message, bool isRightAligned) {
    final BoxDecoration boxDecoration = BoxDecoration(
      color: isRightAligned ? Colors.blue[100] : Colors.grey[300],
      borderRadius: BorderRadius.only(
        bottomLeft: const Radius.circular(20),
        bottomRight: const Radius.circular(20),
        topLeft: !isRightAligned
            ? const Radius.circular(0)
            : const Radius.circular(20),
        topRight: isRightAligned
            ? const Radius.circular(0)
            : const Radius.circular(20),
      ),
    );

    final CrossAxisAlignment crossAxisAlignment =
        isRightAligned ? CrossAxisAlignment.stretch : CrossAxisAlignment.start;

    final EdgeInsets padding = isRightAligned
        ? const EdgeInsets.only(left: 60, right: 10, top: 5, bottom: 5)
        : const EdgeInsets.only(left: 10, right: 60, top: 5, bottom: 5);

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isRightAligned)
            CircleAvatar(
              backgroundImage: NetworkImage(message.characterImg),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              decoration: boxDecoration,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  ///*** Sender name */
                  // Text(
                  //   message.characterName,
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  const SizedBox(height: 5),
                  Text(
                    message.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _timestampToString(message.timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isRightAligned)
            const SizedBox(
              width: 8,
            ),
          if (isRightAligned)
            CircleAvatar(
              backgroundImage: NetworkImage(message.characterImg),
            ),
        ],
      ),
    );
  }

  String _timestampToString(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = DateFormat('yyyy-MM-dd hh:mm');
    return formatter.format(date);
  }

  void _scrollToBottomAfterBuild() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
