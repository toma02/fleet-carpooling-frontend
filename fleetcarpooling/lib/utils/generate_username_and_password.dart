import 'dart:math';

import 'package:firebase_database/firebase_database.dart';

Future<bool> checkUsernameExistence(String username) async {
  bool provjera = false;
  final databaseReference = FirebaseDatabase.instance.ref();
  var query = databaseReference
      .child("Users")
      .orderByChild('username')
      .equalTo(username)
      .limitToFirst(1);

  DatabaseEvent snapshot = await query.once();

  if (snapshot.snapshot.value != null) {
    provjera = true;
  }

  return provjera;
}

Future<String> generateUsername(String firstName, String lastName) async {
  String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
  String lastFourDigits = uniqueName.substring(uniqueName.length - 4);

  String firstLetter = firstName.substring(0, 1).toLowerCase();

  Map<String, String> change = {
    'š': 's',
    'č': 'c',
    'ć': 'c',
    'đ': 'dj',
    'ž': 'z'
  };

  String newLastName = lastName.toLowerCase();
  change.forEach((key, value) {
    newLastName = newLastName.replaceAll(key, value);
  });
  int year = DateTime.now().year % 100;
  String userName = '$firstLetter$newLastName$year';
  var provjera = await checkUsernameExistence(userName);
  if (provjera == true) {
    userName = '$firstLetter$newLastName$lastFourDigits';
  }

  return userName;
}

String generateRandomPassword() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return List.generate(8, (index) => chars[random.nextInt(chars.length)])
      .join();
}
