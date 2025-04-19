import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class PermissionService {
  // Singleton pattern
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // Only request needed permissions on app launch
  Future<void> requestPermissions() async {
    // Request both permissions at app launch
    await Permission.camera.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  // Request camera permission only
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      // Show rationale before requesting permission
      _showPermissionToast(
        "Camera access is needed to take pictures.",
        Colors.blue,
      );

      // Request the permission
      status = await Permission.camera.request();
    }

    return status.isGranted;
  }

  void _showPermissionToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
