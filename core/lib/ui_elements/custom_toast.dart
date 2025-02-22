import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class CustomToast {
  void showStatusToast(String message, String flagContent, String vehicleIdContent) {
    if (_shouldSkipToast(flagContent)) {
      return;
    }

    String cleanedMessage = _cleanMessage(message, vehicleIdContent);
    showFlutterToast(cleanedMessage);
  }

  bool _shouldSkipToast(String flagContent) {
    return flagContent == "0000" || flagContent == "1001" || flagContent == "1010";
  }

  String _cleanMessage(String message, String vehicleIdContent) {
    String removedFlagContent = message.replaceFirst(RegExp(r'\[.*?\]'), '').trim();
    return removedFlagContent.replaceFirst(RegExp(r'\[.*?\]'), vehicleIdContent).trim();

  }

  void showFlutterToast(String cleanedMessage) {
    Fluttertoast.showToast(
      msg: cleanedMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
