import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/chat/models/message.dart';
import 'package:fleetcarpooling/chat/provider/firebase_provider.dart';
import 'package:fleetcarpooling/chat/widgets/empty_widget.dart';
import 'package:fleetcarpooling/chat/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.receiverId});
  final String receiverId;
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final firebaseProvider =
        FirebaseProvider(FirebaseFirestore.instance, FirebaseDatabase.instance);
    return StreamBuilder<List<Message>>(
      stream: firebaseProvider.getMessages(receiverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: EmptyWidget(icon: Icons.waving_hand, text: 'Say Hello!'),
          );
        } else if (snapshot.hasError) {
          return const Expanded(
            child:
                EmptyWidget(icon: Icons.error, text: 'Something went wrong!'),
          );
        } else {
          final messages = snapshot.data ?? [];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (messages.length > 3) {
              itemScrollController.scrollTo(
                  index: messages.length,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut);
            }
          });
          return Expanded(
            child: ScrollablePositionedList.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isTextMessage =
                    messages[index].messageType == MessageType.text;
                final isMe = FirebaseAuth.instance.currentUser?.uid ==
                    messages[index].senderId;
                return isTextMessage
                    ? MessageBubble(
                        isMe: isMe,
                        message: messages[index],
                        isImage: false,
                      )
                    : MessageBubble(
                        isMe: isMe,
                        message: messages[index],
                        isImage: true,
                      );
              },
              itemScrollController: itemScrollController,
            ),
          );
        }
      },
    );
  }
}
