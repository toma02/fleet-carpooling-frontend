import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class ImageRepository {
  Future<String> uploadImageGallery();
  Future<String> uploadImageCamera();
}

class UploadImage implements ImageRepository {
  @override
  Future<String> uploadImageCamera() async {
    ImagePicker imagePickerCamera = ImagePicker();
    XFile? file = await imagePickerCamera.pickImage(source: ImageSource.camera);
    if (file == null) return "";
    return addStorage(file);
  }

  @override
  Future<String> uploadImageGallery() async {
    ImagePicker imagePickerGallery = ImagePicker();
    XFile? file =
        await imagePickerGallery.pickImage(source: ImageSource.gallery);
    if (file == null) return "";
    return addStorage(file);
  }

  Future<String> addStorage(XFile file) async {
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueName);
    referenceImageToUpload.putFile(File(file.path));
    try {
      await referenceImageToUpload.putFile(File(file.path));
      return await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      return "error";
    }
  }
}
