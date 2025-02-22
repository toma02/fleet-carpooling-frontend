import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/services/reservation_service.dart';
import 'package:fleetcarpooling/auth/auth_notify_me.dart';
import 'package:fleetcarpooling/auth/auth_notification.dart';
import 'package:fleetcarpooling/Models/user_model.dart' as usermod;

class UserRepository {
  Future<usermod.User> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$uid");

        DatabaseEvent event = await ref.once();

        Map<dynamic, dynamic>? userData =
            event.snapshot.value as Map<dynamic, dynamic>?;

        return usermod.User(
          firstName: userData?['firstName'] ?? '',
          lastName: userData?['lastName'] ?? '',
          email: userData?['email'] ?? '',
          username: userData?['username'] ?? '',
          role: userData?['role'] ?? '',
          profileImage: userData?['profileImage'] ?? '',
          statusActivity: userData?['isOnline'] ?? '',
        );
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
      rethrow;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error changing password: $e");
      rethrow;
    }
  }

  Future<void> passwordReset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      rethrow;
    }
  }

  Stream<List<usermod.User>> getUsers() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users");
    final StreamController<List<usermod.User>> controller =
        StreamController<List<usermod.User>>();
    ref.onValue.listen((DatabaseEvent event) {
      List<usermod.User> allUsers = [];

      Map<dynamic, dynamic>? values =
          event.snapshot.value as Map<dynamic, dynamic>?;
      values?.forEach((key, value) {
        allUsers.add(usermod.User(
          firstName: value?['firstName'] ?? '',
          lastName: value?['lastName'] ?? '',
          email: value?['email'] ?? '',
          username: value?['username'] ?? '',
          role: value?['role'] ?? '',
          profileImage: value?['profileImage'] ?? '',
          statusActivity: value?['isOnline'] ?? '',
        ));
      });

      controller.add(allUsers);
    });
    return controller.stream;
  }

  Future<bool> deleteUser(String email) async {
    late final ReservationService reservationService = ReservationService();
    late final AuthNotification authNotification =
        AuthNotification(FirebaseAuth.instance, FirebaseDatabase.instance);
    late final AuthNotifyMe authNotifyMe = AuthNotifyMe();

    DatabaseReference ref = FirebaseDatabase.instance.ref("Users");

    DatabaseEvent snapshot = await FirebaseDatabase.instance
        .ref("Users")
        .orderByChild('email')
        .equalTo(email)
        .once();

    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? users =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;
      String? key = users?.keys.first;
      await ref.child(key!).remove();
      await reservationService.deleteAllUserReservations(email);
      await authNotification.deleteAllUserNotifications(email);
      await authNotifyMe.deleteAllUserNotifyMeNotifications(email);
      return true;
    }
    return false;
  }

  Future<String?> getUserNameByEmail(String email) async {
    try {
      DatabaseEvent snapshot = await FirebaseDatabase.instance
          .ref("Users")
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic>? users =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        String? key = users?.keys.first;
        Map<dynamic, dynamic>? userData = users?[key];

        String firstName = userData?['firstName'] ?? '';
        String lastName = userData?['lastName'] ?? '';

        return '$firstName $lastName';
      }

      return null;
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching full name: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfileImage(String imageUrl) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;

        DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$uid");

        await ref.update({
          'profileImage': imageUrl,
        });
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error updating profile image: $e");
      rethrow;
    }
  }
}
