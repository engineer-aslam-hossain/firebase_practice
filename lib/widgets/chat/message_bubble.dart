import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userImage;
  final Key? key;

  MessageBubble(this.message, this.isMe, this.username, this.userImage,
      {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: isMe ? Radius.circular(20) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: isMe ? 120 : 200,
          top: 0,
          child: CircleAvatar(
            radius: 16,
            backgroundColor:
                isMe ? Colors.greenAccent : Theme.of(context).primaryColor,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(userImage),
            ),
          ),
        ),
        Positioned(
          top: -5,
          right: isMe ? 20 : 0,
          left: isMe ? 0 : 20,
          child: Text(
            username,
            style: TextStyle(
              color: isMe
                  ? Colors.greenAccent[700]
                  : Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        )
      ],
      clipBehavior: Clip.none,
    );
  }
}
