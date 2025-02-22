import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:fleetcarpooling/chat/models/message.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  FirebaseProvider(this.firestore, this.firebaseDatabase);
  FirebaseFirestore firestore;
  FirebaseDatabase firebaseDatabase;
  ScrollController scrollController = ScrollController();
  List<Message> messages = [];

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DatabaseReference ref = firebaseDatabase.ref("Users/$userId");
      DatabaseEvent event = await ref.once();
      Map<dynamic, dynamic>? userData =
          event.snapshot.value as Map<dynamic, dynamic>?;
      return userData?.map((key, value) => MapEntry(key.toString(), value)) ??
          {};
    } catch (error) {
      throw Exception("Error fetching user data: $error");
    }
  }

  Stream<List<Message>> getMessages(String receiverId) {
    return firestore
        .collection('chat')
        .doc(receiverId)
        .collection('message')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .map((messages) {
      return messages.docs.map((doc) => Message.fromJson(doc.data())).toList();
    });
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}
