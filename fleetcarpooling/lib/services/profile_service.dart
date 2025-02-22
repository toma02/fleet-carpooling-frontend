import 'package:firebase_database/firebase_database.dart';
import 'package:fleetcarpooling/services/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

class ProfileService {
  static final firestore = FirebaseFirestore.instance;

  Future<String> addStorage({required XFile file}) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot
        .child('profile_images/${FirebaseAuth.instance.currentUser?.uid}}');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueName);
    referenceImageToUpload.putFile(File(file.path));

    try {
      await referenceImageToUpload.putFile(File(file.path));
      String downloadURL = await referenceImageToUpload.getDownloadURL();
      await UserRepository().updateUserProfileImage(downloadURL);
      return await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      return "error";
    }
  }

  Future<void> deleteProfileImage(String url) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;

        FirebaseStorage.instance.refFromURL(url).delete();
        DatabaseReference ref = FirebaseDatabase.instance.ref("Users/$uid");

        await ref.update({
          'profileImage': '',
        });

        await UserRepository().updateUserProfileImage('');
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error deleting profile image: $e");
      rethrow;
    }
  }
}
