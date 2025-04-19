import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DecodingService {
  // Singleton pattern
  static final DecodingService _instance = DecodingService._internal();
  factory DecodingService() => _instance;
  DecodingService._internal();

  Future<String?> decodeDataFromImage(File imageFile) async {
    try {
      // Read image file
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image? encodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

      if (encodedImage == null) {
        _showToast("Failed to load image", Colors.red);
        return null;
      }

      // Extract binary data from image using 2nd LSB
      String extractedBinary = '';

      // First extract 32 bits to determine the length of the hidden data
      for (int i = 0; i < 32; i++) {
        int pixelIndex = i ~/ 3;
        int colorIndex = i % 3;
        int x = pixelIndex % encodedImage.width;
        int y = pixelIndex ~/ encodedImage.width;

        img.Pixel pixel = encodedImage.getPixel(x, y);
        int colorValue;

        if (colorIndex == 0) {
          colorValue = pixel.r.toInt();
        } else if (colorIndex == 1) {
          colorValue = pixel.g.toInt();
        } else {
          colorValue = pixel.b.toInt();
        }

        // Get the 2nd least significant bit
        extractedBinary += ((colorValue & 2) >> 1).toString();
      }

      // Convert binary length to integer
      int dataLength = int.parse(extractedBinary, radix: 2);

      // Validate the extracted length
      int maxCapacity = encodedImage.width * encodedImage.height * 3 - 32;
      if (dataLength <= 0 || dataLength > maxCapacity) {
        _showToast("No valid data found in this image", Colors.orange);
        return null;
      }

      // Extract the actual data
      extractedBinary = '';
      for (int i = 32; i < 32 + dataLength; i++) {
        int pixelIndex = i ~/ 3;
        int colorIndex = i % 3;
        int x = pixelIndex % encodedImage.width;
        int y = pixelIndex ~/ encodedImage.width;

        // Make sure we don't exceed image dimensions
        if (y >= encodedImage.height) break;

        img.Pixel pixel = encodedImage.getPixel(x, y);
        int colorValue;

        if (colorIndex == 0) {
          colorValue = pixel.r.toInt();
        } else if (colorIndex == 1) {
          colorValue = pixel.g.toInt();
        } else {
          colorValue = pixel.b.toInt();
        }

        // Get the 2nd least significant bit
        extractedBinary += ((colorValue & 2) >> 1).toString();
      }

      // Convert binary to text
      String decodedText = _binaryToText(extractedBinary);
      if (decodedText.isEmpty) {
        _showToast("No hidden data found", Colors.orange);
        return null;
      }

      return decodedText;
    } catch (e) {
      _showToast("Error decoding data: $e", Colors.red);
      return null;
    }
  }

  // Convert binary to text
  String _binaryToText(String binary) {
    List<String> bytes = [];
    for (int i = 0; i < binary.length; i += 8) {
      if (i + 8 <= binary.length) {
        bytes.add(binary.substring(i, i + 8));
      }
    }

    String result = '';
    for (String byte in bytes) {
      int charCode = int.parse(byte, radix: 2);
      if (charCode > 0) {
        // Ensure we're not adding null characters
        result += String.fromCharCode(charCode);
      }
    }

    return result;
  }

  // Display toast message
  void _showToast(String message, Color backgroundColor) {
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
