import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:fleetcarpooling/auth/auth_registration_service.dart';
import 'package:fleetcarpooling/utils/generate_username_and_password.dart';
import 'package:fleetcarpooling/utils/send_email.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mailer/mailer.dart';

class UserRepository {
  UserRepository(this.firebaseDatabase);
  FirebaseDatabase firebaseDatabase;
  Future<Map<dynamic, dynamic>> getUser(String userId) async {
    final userNode = firebaseDatabase.ref().child('Users/$userId');
    final dataSnapshot = await userNode.once();
    DataSnapshot snapshot = dataSnapshot.snapshot;
    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
    return values;
  }
}

void main() {
  final auth = MockFirebaseAuth();
  FirebaseDatabase firebaseDatabase;
  UserRepository? userRepository;
  AuthRegistrationService? authRegistrationService;

  const userId = 'userId';
  const userName = 'Elon musk';
  const fakeData = {
    'Users': {
      userId: {
        'username': userName,
        'email': 'musk.email@tesla.com',
        'photoUrl': 'url-to-photo.jpg',
      },
      'otherUserId': {
        'username': 'userName',
        'email': 'othermusk.email@tesla.com',
        'photoUrl': 'other_url-to-photo.jpg',
      }
    }
  };
  MockFirebaseDatabase.instance.ref().set(fakeData);
  setUp(() {
    firebaseDatabase = MockFirebaseDatabase.instance;
    userRepository = UserRepository(firebaseDatabase);
    authRegistrationService = AuthRegistrationService(firebaseDatabase, auth);
    dotenv.load();
  });
  group("UserRegistration", () {
    test('Generates a random password of correct length', () {
      final password = generateRandomPassword();
      expect(password.length, equals(8));
    });

    test('Generates a random password of correct characters', () {
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      final password = generateRandomPassword();
      for (int i = 0; i < password.length; i++) {
        expect(chars.contains(password[i]), isTrue);
      }
    });
    test('Should write user in database', () async {
      // Define new user data
      const newUserId = 'newUserId';
      const newUserName = 'New User';
      const newUserEmail = 'new.user@email.com';
      const newUserFirstName = 'New';
      const newUserLastName = 'User';
      const newUserRole = 'User';
      const newUser = {
        'username': newUserName,
        'email': newUserEmail,
        'firstName': newUserFirstName,
        'lastName': newUserLastName,
        'role': newUserRole,
        'profileImage': '',
        'statusActivity': 'offline',
      };

      authRegistrationService?.writeDataToDatabase(newUserId, newUserName,
          newUserEmail, newUserFirstName, newUserLastName, newUserRole);

      final newUserFromDatabase = await userRepository?.getUser(newUserId);

      expect(
        newUserFromDatabase,
        equals(newUser),
      );
    });
    test('Sending email should pass with valid inputs', () async {
      const email = 'domagojsantek70@gmail.com';
      const usernameLogin = 'testUser';
      const passwordLogin = 'testPassword';
      expect(sendEmail(email, auth, usernameLogin, passwordLogin), completes);
    });

    test('Should throws MailerException', () async {
      const email = 'mail'; // Invalid email
      const usernameLogin = 'testUser';
      const passwordLogin = 'testPassword';

      await expectLater(
        sendEmail(email, auth, usernameLogin, passwordLogin),
        throwsA(isA<MailerException>()),
      );
    });
  });
}
