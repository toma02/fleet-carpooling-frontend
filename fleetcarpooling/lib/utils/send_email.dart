// ignore_for_file: avoid_print

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendEmail(String email, FirebaseAuth auth, String usernameLogin,
    String passwordLogin) async {
  String username = dotenv.env['EMAIL_USERNAME']!;
  String password = dotenv.env['EMAIL_PASSWORD']!;

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'FleetCarpooling')
    ..recipients.add(email)
    ..subject = 'Welcome to FleetCarpooling'
    ..html =
        "<h3>Welcome to FleetCarpooling</h3>\n<p>You have been successfully added to the application.</p>\n<p>Your username is <b>$usernameLogin</b> and the password you can use to log in is <b>$passwordLogin</b>. Please change your password during your first login or using the password change link that will be active 1 hour after receiving it.</p>\n<p>In a few moments, you will receive a link where you can set your password.</p>\n\n<p>Best regards!</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: $sendReport');
    Future.delayed(const Duration(minutes: 1), () {
      sendLinkForNewPassword(email, auth);
    });
  } catch (e) {
    rethrow;
  }
}

Future<void> sendLinkForNewPassword(String email, FirebaseAuth auth) async {
  try {
    await auth.sendPasswordResetEmail(email: email);
    print('Password reset email sent to $email');
  } catch (e) {
    print('Error sending password reset email: $e');
    // Handle errors as needed
  }
}

Future<void> sendReservationEmail(String email, String datePickup,
    String timePickup, String dateReturn, String timeReturn) async {
  String username = dotenv.env['EMAIL_USERNAME']!;
  String password = dotenv.env['EMAIL_PASSWORD']!;

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'FleetCarpooling')
    ..recipients.add(email)
    ..subject = 'Reservation confirmation'
    ..html =
        "<h3>Reservation confirmation</h3>\n<p></p>\n<p>You have reservation on day <b>$datePickup</b> at <b>$timePickup</b> until <b>$dateReturn</b> at <b>$timeReturn</b>.";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: $sendReport');
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
