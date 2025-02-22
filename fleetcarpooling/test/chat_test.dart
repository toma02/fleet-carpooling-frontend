import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/auth/auth_login.dart';
import 'package:fleetcarpooling/chat/models/message.dart';
import 'package:fleetcarpooling/chat/provider/firebase_provider.dart';
import 'package:fleetcarpooling/chat/service/firebase_firestore_service.dart';
import 'package:fleetcarpooling/chat/service/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';

class MockNotificationsService extends Mock implements NotificationsService {
  @override
  Future<void> getToken(String receiverId) {
    return noSuchMethod(Invocation.method(#getToken, [receiverId]),
        returnValue: Future.value(), returnValueForMissingStub: Future.value());
  }
}

void main() {
  const userId = 'userId';
  const userName = 'Elon musk';
  const fakeData = {
    'Users': {
      userId: {
        'name': userName,
        'email': 'musk.email@tesla.com',
        'photoUrl': 'url-to-photo.jpg',
        'statusActivity': 'online'
      },
      'otherUserId': {
        'name': 'userName',
        'email': 'othermusk.email@tesla.com',
        'photoUrl': 'other_url-to-photo.jpg',
        'statusActivity': 'offline'
      }
    }
  };

  const fakeDataVehicle = {
    'Vehicles': {
      '12345678': {
        'model': "A4",
        'brand': 'Audi',
        'token': {'12348': '12348', '54615': '54615'}
      },
      'otherVehicleId': {
        'model': "5",
        'brand': 'BMW',
        'token': {"12348": "12348", "54615": "54615"}
      }
    }
  };
  final auth = MockFirebaseAuth();
  NotificationsService? notificationService;
  AuthLogin? authLogin;
  FirebaseDatabase firebaseDatabase;
  FirebaseDatabase firebaseDatabaseVehicle;

  group('NotificationChat', () {
    setUp(() {
      MockFirebaseDatabase.instance.ref().set(fakeDataVehicle);
      firebaseDatabaseVehicle = MockFirebaseDatabase.instance;
      notificationService = NotificationsService(firebaseDatabaseVehicle);
    });

    test('Get vehicle token', () async {
      const receiverId = '12345678';
      final expectedTokens = ['12348', '54615'];

      await notificationService?.getReceiverToken(receiverId);

      expect(notificationService?.receiverToken, equals(expectedTokens));
    });

    test('Receiver token is empty', () async {
      const receiverId = '1234567845';

      await notificationService?.getReceiverToken(receiverId);

      expect(notificationService?.receiverToken, isEmpty);
    });

    test('saveToken should save token', () async {
      const receiverId = '12345678';
      final expectedTokens = ['12348', '54615', '1111'];
      await notificationService
          ?.saveToken(
            "1111",
            receiverId,
          )
          .whenComplete(
              () => notificationService?.getReceiverToken(receiverId));

      expect(notificationService?.receiverToken, expectedTokens);
    });

    test('saveToken should not save token', () async {
      const receiverId = '12345678';
      final expectedTokens = ['12348', '54615'];
      await notificationService
          ?.saveToken(
            "1111",
            "123456789",
          )
          .whenComplete(
              () => notificationService?.getReceiverToken(receiverId));

      expect(notificationService?.receiverToken, expectedTokens);
    });
  });

  group('Chat', () {
    late FakeFirebaseFirestore firestore;
    late FirebaseFirestoreService firestoreChat;
    late FirebaseProvider firestoreProvider;
    late MockNotificationsService mockNotificationsService;

    setUp(() {
      MockFirebaseDatabase.instance.ref().set(fakeData);
      firebaseDatabase = MockFirebaseDatabase.instance;
      firestore = FakeFirebaseFirestore();
      mockNotificationsService = MockNotificationsService();
      firestoreChat =
          FirebaseFirestoreService(firestore, auth, mockNotificationsService);
      firestoreProvider = FirebaseProvider(firestore, firebaseDatabase);
      authLogin = AuthLogin(firebaseDatabase, auth);
    });

    test('User is offline', () async {
      const uid = userId;
      const expectedStatus = 'offline';

      authLogin?.updateOnlineStatus(uid, expectedStatus);

      final userNameFromFakeDatabase =
          await firestoreProvider.getUserData(userId);
      expect(
        userNameFromFakeDatabase,
        equals({
          'name': userName,
          'email': 'musk.email@tesla.com',
          'photoUrl': 'url-to-photo.jpg',
          'statusActivity': 'offline'
        }),
      );
    });

    test('User is online', () async {
      const uid = 'otherUserId';
      const expectedStatus = 'online';

      authLogin?.updateOnlineStatus(uid, expectedStatus);

      final userNameFromFakeDatabase =
          await firestoreProvider.getUserData(userId);

      expect(
        userNameFromFakeDatabase,
        equals({
          'name': userName,
          'email': 'musk.email@tesla.com',
          'photoUrl': 'url-to-photo.jpg',
          'statusActivity': 'online'
        }),
      );
    });

    test('Get user by id', () async {
      final userNameFromFakeDatabase =
          await firestoreProvider.getUserData(userId);
      expect(
        userNameFromFakeDatabase,
        equals({
          'name': userName,
          'email': 'musk.email@tesla.com',
          'photoUrl': 'url-to-photo.jpg',
          'statusActivity': 'online'
        }),
      );
    });
    test('Add message to chat', () async {
      const receiverId = 'testReceiverId';
      final message = Message(
          senderId: "123",
          receiverId: "1234",
          sentTime: DateTime.parse('2024-01-26 23:33:53.941260'),
          content: "pozdrav",
          messageType: MessageType.text);

      when(mockNotificationsService.getToken(receiverId))
          .thenAnswer((_) async => 'testToken');

      await firestoreChat.addMessageToChat(receiverId, message);

      final messages = await firestore
          .collection('chat')
          .doc(receiverId)
          .collection('message')
          .get();

      final actualData = messages.docs.first.data();
      actualData['sentTime'] = (actualData['sentTime'] as Timestamp).toDate();
      expect(actualData, message.toJson());

      verify(mockNotificationsService.getToken(receiverId)).called(1);
    });
    test('Get messages', () async {
      const receiverId = 'testReceiverId';
      final message = Message(
          senderId: "123",
          receiverId: "1234",
          sentTime: DateTime.parse('2024-01-26 23:33:53.941260'),
          content: "pozdrav",
          messageType: MessageType.text);

      await firestoreChat.addMessageToChat(receiverId, message);

      final messagesStream = firestoreProvider.getMessages(receiverId);

      final messages = await messagesStream.first;

      expect(messages.first.toJson(), message.toJson());
    });
    test('Get multiple messages', () async {
      const receiverId = 'testReceiverId';
      final message1 = Message(
          senderId: "123",
          receiverId: "1234",
          sentTime: DateTime.parse('2024-01-26 23:33:53.941260'),
          content: "pozdrav",
          messageType: MessageType.text);
      final message2 = Message(
          senderId: "1235",
          receiverId: "1234uu",
          sentTime: DateTime.parse('2024-01-27 23:34:53.941260'),
          content: "kako si",
          messageType: MessageType.text);

      await firestoreChat.addMessageToChat(receiverId, message1);
      await firestoreChat.addMessageToChat(receiverId, message2);

      final messagesStream = firestoreProvider.getMessages(receiverId);

      final messages = await messagesStream.first;

      expect(messages.length, 2);
      expect(messages[0].toJson(), message1.toJson());
      expect(messages[1].toJson(), message2.toJson());
    });
  });
}
