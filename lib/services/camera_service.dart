import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> takeImageWithCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
