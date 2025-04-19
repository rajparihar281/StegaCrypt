import 'dart:io';
import 'package:data_hiding_app/components/custom_button.dart'
    show CustomButton;
import 'package:data_hiding_app/components/image_preview.dart'
    show ImagePreview;
import 'package:data_hiding_app/services/camera_service.dart'
    show CameraService;
import 'package:data_hiding_app/services/decoding_service.dart'
    show DecodingService;
import 'package:data_hiding_app/views/decode_result_page.dart'
    show DecodedResultPage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DecodePage extends StatefulWidget {
  const DecodePage({super.key});

  @override
  State<DecodePage> createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage> {
  final CameraService _cameraService = CameraService();
  final DecodingService _decodingService = DecodingService();
  File? _selectedImage;
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final File? image = await _cameraService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _decodeData() async {
    if (_selectedImage == null) {
      _showToast("Please select an image first", Colors.red);
      return;
    }

    setState(() {
      _isProcessing = true;
    });
    try {
      final String? decodedText = await _decodingService.decodeDataFromImage(
        _selectedImage!,
      );

      setState(() {
        _isProcessing = false;
      });

      if (decodedText != null && decodedText.isNotEmpty) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => DecodedResultPage(decodedText: decodedText),
          ),
        );
      } else {
        _showToast("No hidden data found", Colors.orange);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showToast("Error: $e", Colors.red);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Ensure full width
        height: double.infinity, // Ensure full height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF121212), Color(0xFF1E1E30), Color(0xFF252550)],
          ),
        ),
        child: SafeArea(
          child:
              _isProcessing
                  ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitWave(color: Colors.white, size: 50.0),
                        SizedBox(height: 20),
                        Text(
                          'Decoding data...',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                  : Column(
                    children: [
                      // App bar area
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              'Decode Data',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content area - takes all remaining space
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomButton(
                                text: 'Select Image',
                                icon: Icons.photo_library,
                                backgroundColor: Colors.purpleAccent,
                                onPressed: _pickImage,
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: ImagePreview(
                                  image: _selectedImage,
                                  onClear: _clearImage,
                                ),
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                text: 'Decode',
                                icon: Icons.lock_open,
                                backgroundColor: Colors.blueAccent,
                                onPressed: _decodeData,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
