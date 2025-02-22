import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fleetcarpooling/screens/profile/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fleetcarpooling/Models/user_model.dart';
import 'package:fleetcarpooling/services/user_repository.dart';

void main() {
  late UserRepository userRepository;

  setUp(() {
    userRepository = UserRepository();
  });

  test('userProfile is initialized with default values', () {
    late User userProfile;

    userProfile = User(
      firstName: '',
      lastName: '',
      email: '',
      username: '',
      role: '',
      profileImage: '',
      statusActivity: '',
    );

    expect(userProfile.firstName, '');
    expect(userProfile.lastName, '');
    expect(userProfile.email, '');
    expect(userProfile.username, '');
    expect(userProfile.role, '');
    expect(userProfile.profileImage, '');
    expect(userProfile.statusActivity, '');
  });

  test('userRepository is initialized', () {
    expect(userRepository, isNotNull);
  });

  testWidgets('ProfilePage has a title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ProfilePage(),
    ));

    await tester.pumpAndSettle();
    expect(find.text('MY PROFILE'), findsOneWidget);
  });

  testWidgets('ProfilePage displays profile image if available',
      (WidgetTester tester) async {
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'john.doe@example.com',
      displayName: 'John Doe',
      photoURL: 'https://example.com/profile.jpg',
    );
    final auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithEmailAndPassword(
        email: "john.doe@example.com", password: "123");

    await tester.pumpWidget(const MaterialApp(
      home: ProfilePage(),
    ));

    expect(find.byType(CircleAvatar), findsOneWidget);
  });
}
