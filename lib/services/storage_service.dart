import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class StorageService {
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Check if directory exists, create if not
  Future<bool> ensureDirectoryExists(String path) async {
    try {
      Directory directory = Directory(path);
      if (await directory.exists()) {
        return true;
      } else {
        await directory.create(recursive: true);
        return true;
      }
    } catch (e) {
      _showErrorToast("Failed to access storage: $e");
      return false;
    }
  }

  // Save file to app's internal storage instead of external
  Future<String?> saveImageToAppDirectory(
    File imageFile,
    String fileName,
  ) async {
    try {
      // Get the app's directory
      Directory appDocDir = await Directory.systemTemp.createTemp('images');

      // Create the destination file
      File destinationFile = File('${appDocDir.path}/$fileName');

      // Copy the file
      await imageFile.copy(destinationFile.path);
      return destinationFile.path;
    } catch (e) {
      _showErrorToast("Failed to save image: $e");
      return null;
    }
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
