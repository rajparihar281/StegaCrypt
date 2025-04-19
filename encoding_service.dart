import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:fluttertoast/fluttertoast.dart';

class EncodingService {
  // Singleton pattern
  static final EncodingService _instance = EncodingService._internal();
  factory EncodingService() => _instance;
  EncodingService._internal();

  Future<String?> encodeDataIntoImage(String text, File imageFile) async {
    try {
      // Read image file
      List<int> imageBytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(
        Uint8List.fromList(imageBytes),
      );

      if (originalImage == null) {
        _showToast("Failed to load image", Colors.red);
        return null;
      }

      // Convert text to binary
      String binaryData = _textToBinary(text);
      int dataLength = binaryData.length;

      // Ensure image can store the data
      int maxCapacity = originalImage.width * originalImage.height * 3 - 32;
      if (dataLength > maxCapacity) {
        _showToast("Text is too large for this image", Colors.red);
        return null;
      }

      // Embed length of the data first (32-bit integer)
      String lengthBinary = dataLength.toRadixString(2).padLeft(32, '0');
      String fullBinaryData = lengthBinary + binaryData;

      int dataIndex = 0;
      for (int y = 0; y < originalImage.height; y++) {
        for (int x = 0; x < originalImage.width; x++) {
          if (dataIndex >= fullBinaryData.length) break;

          img.Pixel pixel = originalImage.getPixel(x, y);
          int r = _setLSB(pixel.r.toInt(), fullBinaryData[dataIndex++] == '1');
          int g =
              (dataIndex < fullBinaryData.length)
                  ? _setLSB(pixel.g.toInt(), fullBinaryData[dataIndex++] == '1')
                  : pixel.g.toInt();
          int b =
              (dataIndex < fullBinaryData.length)
                  ? _setLSB(pixel.b.toInt(), fullBinaryData[dataIndex++] == '1')
                  : pixel.b.toInt();

          originalImage.setPixelRgba(x, y, r, g, b, pixel.a.toInt());
        }
      }

      // Save modified image
      Uint8List encodedBytes = Uint8List.fromList(img.encodePng(originalImage));
      String fileName = 'encoded_${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        // First ensure directory exists - without permission check
        Directory directory = Directory('/storage/emulated/0/DCIM/');
        if (!(await directory.exists())) {
          await directory.create(recursive: true);
        }

        String filePath = '/storage/emulated/0/DCIM/$fileName';
        File outputFile = File(filePath);
        await outputFile.writeAsBytes(encodedBytes);

        _showToast("Encoded image saved to gallery", Colors.green);
        return filePath;
      } catch (e) {
        // If external storage fails, try saving to app's cache directory as fallback
        final directory = await Directory.systemTemp.createTemp(
          'encoded_images',
        );
        final filePath = '${directory.path}/$fileName';
        final outputFile = File(filePath);
        await outputFile.writeAsBytes(encodedBytes);

        _showToast(
          "Encoded image saved to app storage: $filePath",
          Colors.orange,
        );
        return filePath;
      }
    } catch (e) {
      _showToast("Error encoding data: $e", Colors.red);
      return null;
    }
  }

  // Convert text to binary
  String _textToBinary(String text) {
    return text.codeUnits
        .map((char) => char.toRadixString(2).padLeft(8, '0'))
        .join();
  }

  // Modify the least significant bit
  int _setLSB(int colorValue, bool bit) {
    return (colorValue & 0xFE) | (bit ? 1 : 0);
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
