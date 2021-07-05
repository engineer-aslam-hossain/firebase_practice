import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/widgets/chat/message_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            final document = chatSnapshot.data?.docs;
            final user = FirebaseAuth.instance.currentUser;

            return user == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: document?.length,
                    itemBuilder: (ctx, indx) => MessageBubble(
                      document?[indx]['text'],
                      document?[indx]['userId'] == user.uid,
                      document?[indx]['username'],
                      document?[indx]['userImage'],
                      key: ValueKey(document?[indx].id),
                    ),
                  );
          }
        });
  }
}
