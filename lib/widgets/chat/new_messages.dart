import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/constant.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var _enteredMessage;
  final _textFieldController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    _textFieldController.clear();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });

    setState(() {
      _enteredMessage = null;
    });
    // print(_enteredMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: kInputDecoration.copyWith(
                labelText: 'Send Message...',
              ),
              style: TextStyle(height: 0.8),
              controller: _textFieldController,
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage == null ? null : _sendMessage,
            icon: Icon(
              Icons.send,
              size: 36,
            ),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
