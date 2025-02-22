import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/chat/service/notification_service.dart';
import 'package:fleetcarpooling/secure/secure_storage.dart';

class AuthLogin {
  AuthLogin(this.database, this._auth);
  FirebaseDatabase database;
  final FirebaseAuth _auth;
  final SecureStorage storage = SecureStorage();
  void updateOnlineStatus(String? uid, String state) async {
    DatabaseReference ref = database.ref("Users/$uid");
    await ref.update({"statusActivity": state});
  }

  Future<String> findEmail(String username) async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    var query = await databaseReference
        .child("Users")
        .orderByChild('username')
        .equalTo(username)
        .limitToFirst(1)
        .once();

    if (query.snapshot.value != null) {
      Map<dynamic, dynamic>? userMap =
          query.snapshot.value as Map<dynamic, dynamic>?;

      if (userMap != null && userMap.isNotEmpty) {
        String userID = userMap.keys.first;
        String userEmail = userMap[userID]['email'];
        return userEmail;
      }
    }

    return "";
  }

  Future<bool> login({required String email, required String password}) async {
    final notificationService = NotificationsService(FirebaseDatabase.instance);
    if (email.contains('@')) {
      email = email;
    } else {
      email = await findEmail(email);
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notificationService.requestPermission();
      storage.addPasswordAndEmail(password, email);
      updateOnlineStatus(userCredential.user!.uid, "online");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isAdmin() async {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$uid");
    DatabaseEvent event = await ref.once();
    Map<dynamic, dynamic>? userData =
        event.snapshot.value as Map<dynamic, dynamic>?;
    if (userData?['role'] == 'Administrator') return true;
    return false;
  }
}
