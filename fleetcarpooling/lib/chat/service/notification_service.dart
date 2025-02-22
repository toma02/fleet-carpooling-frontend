import 'dart:async';
import 'dart:convert';
import 'package:core/models/vehicle.dart';
import 'package:fleetcarpooling/services/vehicle_managament_service.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

class NotificationsService {
  NotificationsService(this.database);
  FirebaseDatabase database;
  static const key =
      'AAAA3qcR1dM:APA91bHXwf9Efc-9arDjVLTUnC6tIf7Ultk_uCkc6WVahtKx8xe-dEdcnICRPjoGBDNIlXrOM6TZ74wrus7bcLugZ-M3_-ttOu7iSD6FHGU6RT3GXYpDNbKpkrNo47wnbCG0X_w8WYJq';
  final navigatorKey = GlobalKey<NavigatorState>();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  void _initLocalNotification() {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings =
        InitializationSettings(android: androidSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      debugPrint(response.payload.toString());
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );
    final androidDetails = AndroidNotificationDetails(
      'com.example.chat_app.urgent',
      'mychannelid',
      importance: Importance.max,
      styleInformation: styleInformation,
      priority: Priority.max,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: message.data['body'],
    );
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken(String receiverId) async {
    final token = await FirebaseMessaging.instance.getToken();
    saveToken(token!, receiverId);
  }

  Future<void> saveToken(String token, String receiverId) async {
    DatabaseReference vehicleRef =
        database.ref().child("Vehicles").child(receiverId).child("token");
    vehicleRef.update({token: token});
  }

  List<String> receiverToken = [];

  Future<void> getReceiverToken(String? receiverId) async {
    List<String> token = [];
    DatabaseReference ref =
        database.ref().child("Vehicles").child(receiverId!).child("token");
    DatabaseEvent snapshot = await ref.once();
    Map<dynamic, dynamic>? values =
        snapshot.snapshot.value as Map<dynamic, dynamic>?;
    values?.forEach((key, value) {
      String tokenValue = value.toString();
      if (!token.contains(tokenValue)) {
        token.add(tokenValue);
      }
    });
    receiverToken = token;
  }

  Future<void> sendNotification(
      {required String body, required String senderId}) async {
    Vehicle? vehicle = await getVehicleByVin(senderId);
    for (int i = 0; i < receiverToken.length; i++) {
      if (receiverToken[i] == await FirebaseMessaging.instance.getToken()) {
      } else {
        try {
          await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$key',
            },
            body: jsonEncode(<String, dynamic>{
              "to": receiverToken[i],
              'priority': 'high',
              'notification': <String, dynamic>{
                'body': body,
                'title':
                    'New Message for ${vehicle?.brand} ${vehicle?.model} !',
              },
              'data': <String, String>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'senderId': senderId,
              }
            }),
          );
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  Future<void> deleteToken() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();
    final token = await FirebaseMessaging.instance.getToken();
    var query = await ref
        .child("Vehicles")
        .orderByChild('token/$token')
        .equalTo(token)
        .once();
    DataSnapshot snapshot = query.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        if (value is Map && value['token'][token] == token) {
          ref
              .child('Vehicles')
              .child(key)
              .child('token')
              .child(token!)
              .remove();
        }
      });
        }
  }

  void firebaseNotification(BuildContext context) {
    _initLocalNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {});
  }
}
