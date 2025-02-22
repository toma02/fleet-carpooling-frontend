import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleetcarpooling/utils/generate_username_and_password.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/utils/send_email.dart';
import 'package:fleetcarpooling/secure/secure_storage.dart';
import '../Models/user_model.dart' as model;

class AuthRegistrationService {
  AuthRegistrationService(this.firebaseDatabase, this.auth);
  FirebaseDatabase firebaseDatabase;
  FirebaseAuth auth;
  final SecureStorage storage = SecureStorage();
  void writeDataToDatabase(String uid, String userName, String email,
      String firstName, String lastName, String role) {
    String profileImage = "";
    model.User user = model.User(
        username: userName,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        profileImage: profileImage,
        statusActivity: "offline");

    DatabaseReference usersRef = firebaseDatabase.ref().child("Users");
    DatabaseReference newUserRef = usersRef.child(uid);

    newUserRef.set(user.toMap());
  }

  Future<void> registerUser(
      String email, String firstName, String lastName, String role) async {
    String password = generateRandomPassword();
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? passwordCurrent = await storage.readPassword();
      String? emailCurrent = await storage.readEmail();
      String userId = userCredential.user!.uid;
      String username = await generateUsername(firstName, lastName);
      writeDataToDatabase(userId, username, email, firstName, lastName, role);
      await sendEmail(email, auth, username, password);
      if (passwordCurrent == null ||
          emailCurrent == null ||
          emailCurrent.isEmpty ||
          passwordCurrent.isEmpty) {
      } else {
        await auth.signOut();
        await auth
            .signInWithEmailAndPassword(
                email: emailCurrent, password: passwordCurrent)
            .whenComplete(() => passwordCurrent = "");
      }
    } on FirebaseAuthException catch (e) {
      if (e.message == "The email address is badly formatted.")
        // ignore: curly_braces_in_flow_control_structures
        throw FirebaseAuthException(code: 'wrong-format');
      else
        // ignore: curly_braces_in_flow_control_structures
        throw FirebaseAuthException(code: 'email-already-in-use');
    } catch (e) {
      throw FirebaseAuthException(code: 'user-not-added');
    }
  }
}
