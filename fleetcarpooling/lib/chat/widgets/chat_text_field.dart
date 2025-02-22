import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/chat/service/firebase_firestore_service.dart';
import 'package:fleetcarpooling/chat/service/notification_service.dart';
import 'package:fleetcarpooling/chat/widgets/custom_text_form_field.dart';
import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({super.key, required this.receiverId});
  final String receiverId;
  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();
  final notification = NotificationsService(FirebaseDatabase.instance);
  Uint8List? file;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: controller,
                hintText: 'Add message',
              ),
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              backgroundColor: AppColors.buttonColor,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _sendText(context),
              ),
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              backgroundColor: AppColors.buttonColor,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _sendImage,
              ),
            ),
          ],
        ),
      );
  Future<void> _sendText(BuildContext context) async {
    notification.getReceiverToken(widget.receiverId);
    if (controller.text.isNotEmpty) {
      String tekst = controller.text;
      controller.clear();
      await FirebaseFirestoreService(
              FirebaseFirestore.instance, FirebaseAuth.instance, notification)
          .addTextMessage(
        receiverId: widget.receiverId,
        content: tekst,
      );
      await notification.sendNotification(
        body: tekst,
        senderId: widget.receiverId,
      );
    }
  }

  Future<void> _sendImage() async {
    notification.getReceiverToken(widget.receiverId);
    ImagePicker imagePickerGallery = ImagePicker();
    XFile? file =
        await imagePickerGallery.pickImage(source: ImageSource.gallery);
    if (file != null) {
      await FirebaseFirestoreService(
              FirebaseFirestore.instance, FirebaseAuth.instance, notification)
          .addImageMessage(
        receiverId: widget.receiverId,
        file: file,
      );
      await notification.sendNotification(
        body: 'image........',
        senderId: widget.receiverId,
      );
    }
  }
}
