// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:data_hiding_app/components/custom_button.dart'
    show CustomButton;
import 'package:data_hiding_app/components/custom_input.dart' show CustomInput;
import 'package:data_hiding_app/components/image_preview.dart'
    show ImagePreview;

import 'package:data_hiding_app/services/camera_service.dart'
    show CameraService;
import 'package:data_hiding_app/services/encoding_service.dart'
    show EncodingService;
import 'package:data_hiding_app/views/instruction_page.dart' show InstructionsPage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EncodePage extends StatefulWidget {
  const EncodePage({super.key});

  @override
  State<EncodePage> createState() => _EncodePageState();
}

class _EncodePageState extends State<EncodePage> {
  final TextEditingController _textController = TextEditingController();
  final CameraService _cameraService = CameraService();
  final EncodingService _encodingService = EncodingService();
  File? _selectedImage;
  bool _isProcessing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final File? image = await _cameraService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _takeImage() async {
    final File? image = await _cameraService.takeImageWithCamera();
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

  void _navigateToInstructions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InstructionsPage()),
    );
  }

  Future<void> _encodeData() async {
    if (_selectedImage == null) {
      _showToast("Please select an image first", Colors.red);
      return;
    }

    if (_textController.text.isEmpty) {
      _showToast("Please enter text to hide", Colors.red);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final String? savedPath = await _encodingService.encodeDataIntoImage(
        _textController.text,
        _selectedImage!,
      );

      setState(() {
        _isProcessing = false;
      });

      if (savedPath != null) {
        _showSuccessDialog(savedPath);
      } else {
        _showToast("Failed to encode data", Colors.red);
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

  void _showSuccessDialog(String imagePath) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Success!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your message has been successfully encoded into the image.',
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(imagePath),
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Saved at: $imagePath',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Clear the form
                  setState(() {
                    _selectedImage = null;
                    _textController.clear();
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                          'Encoding data...',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )
                  : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      const Expanded(
                                        child: Text(
                                          'Encode Data',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.help_outline,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        onPressed: _navigateToInstructions,
                                        tooltip: 'How It Works',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          text: 'Gallery',
                                          icon: Icons.photo_library,
                                          backgroundColor: Colors.purpleAccent,
                                          onPressed: _pickImage,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: CustomButton(
                                          text: 'Camera',
                                          icon: Icons.camera_alt,
                                          backgroundColor: Colors.blueAccent,
                                          onPressed: _takeImage,
                                        ),
                                      ),
                                    ],
                                  ),

                                  ImagePreview(
                                    image: _selectedImage,
                                    onClear: _clearImage,
                                    height: 220,
                                    fit: BoxFit.cover,
                                  ),
                                  CustomInput(
                                    controller: _textController,
                                    hintText: 'Enter your secret text here...',
                                    prefixIcon: Icons.text_fields,
                                    isMultiline: true,
                                    maxLines: 4,
                                  ),
                                  const SizedBox(height: 25),

                                  CustomButton(
                                    text: 'Encode',
                                    icon: Icons.enhanced_encryption,
                                    backgroundColor: Colors.greenAccent[700],
                                    onPressed: _encodeData,
                                  ),

                                  const SizedBox(height: 30),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.lightbulb_outline,
                                              color: Colors.blue[300],
                                              size: 22,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "Quick Tip",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Select a high-quality image for better results. Avoid compressing the image after encoding as it may corrupt the hidden data.",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: _navigateToInstructions,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Learn more",
                                                style: TextStyle(
                                                  color: Colors.blue[300],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.blue[300],
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),

                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: TextButton.icon(
                                        onPressed: _navigateToInstructions,
                                        icon: const Icon(
                                          Icons.info_outline,
                                          size: 18,
                                        ),
                                        label: const Text(
                                          'How steganography works',
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white60,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
