import 'package:core/ui_elements/buttons.dart';
import 'package:fleetcarpooling/chat/widgets/chat_messages.dart';
import 'package:fleetcarpooling/chat/widgets/chat_text_field.dart';
import 'package:core/ui_elements/colors';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.vin, required this.brand, required this.model});
  final String vin;
  final String brand;
  final String model;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            '${widget.brand} ${widget.model} ',
            style: const TextStyle(
                color: AppColors.mainTextColor, fontWeight: FontWeight.w400),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircularIconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Future.delayed(const Duration(milliseconds: 50), () {
                Navigator.pop(context);
              });
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 270),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ChatMessages(receiverId: widget.vin),
                ChatTextField(
                  receiverId: widget.vin,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
