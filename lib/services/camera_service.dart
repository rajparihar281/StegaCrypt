import 'dart:io';
import 'package:data_hiding_app/services/permission_service.dart'
    show PermissionService;
import 'package:image_picker/image_picker.dart';

class CameraService {
  // Singleton pattern
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService = PermissionService();

  // Pick image from gallery (no storage permission required for this)
  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }

  // Take image with camera - with permission check
  Future<File?> takeImageWithCamera() async {
    // Explicitly request camera permission before trying to use the camera
    bool hasPermission = await _permissionService.requestCameraPermission();

    if (!hasPermission) {
      return null;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }
}
