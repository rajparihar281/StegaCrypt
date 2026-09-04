import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:data_hiding_app/services/encoding_service.dart';
import 'package:data_hiding_app/services/decoding_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('PonnamKarthik/fluttertoast');
  
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return true;
    });
  });

  Future<File> createDummyImage(int width, int height) async {
    final image = img.Image(width: width, height: height, numChannels: 3);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        image.setPixelRgba(x, y, 255, 255, 255, 255);
      }
    }
    
    final directory = await Directory.systemTemp.createTemp('stegacrypt_test');
    final file = File('${directory.path}/test_image.png');
    await file.writeAsBytes(img.encodePng(image));
    return file;
  }

  group('Steganography Logic Tests', () {
    late EncodingService encodingService;
    late DecodingService decodingService;

    setUp(() {
      encodingService = EncodingService();
      decodingService = DecodingService();
    });

    test('Encoding and decoding a simple message should return exact same message', () async {
      final dummyFile = await createDummyImage(50, 50);
      const secretMessage = "Hello, this is a secret test message!";
      final encodedFilePath = await encodingService.encodeDataIntoImage(secretMessage, dummyFile);
      expect(encodedFilePath, isNotNull, reason: "Encoding should return a valid file path");
      
      final encodedFile = File(encodedFilePath!);
      expect(await encodedFile.exists(), isTrue, reason: "Encoded file must exist on disk");
      final decodedMessage = await decodingService.decodeDataFromImage(encodedFile);
      expect(decodedMessage, equals(secretMessage));
    });

    test('Encoding a message that exceeds image capacity should return null', () async {
      final dummyFile = await createDummyImage(5, 5);
      const largeMessage = "This is a very long message for a tiny image";
      
      final encodedFilePath = await encodingService.encodeDataIntoImage(largeMessage, dummyFile);
      expect(encodedFilePath, isNull);
    });

    test('Decoding an image with no hidden data should return null', () async {
      final dummyFile = await createDummyImage(20, 20);
      
      final decodedMessage = await decodingService.decodeDataFromImage(dummyFile);
      expect(decodedMessage, isNull);
    });
  });
}
