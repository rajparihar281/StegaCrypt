import 'dart:io';
import 'package:data_hiding_app/services/camera_service.dart' show CameraService;
import 'package:data_hiding_app/services/decoding_service.dart' show DecodingService;
import 'package:data_hiding_app/views/decode_result_page.dart' show DecodedResultPage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:data_hiding_app/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
      setState(() => _selectedImage = image);
    }
  }

  void _clearImage() {
    setState(() => _selectedImage = null);
  }

  Future<void> _decodeData() async {
    if (_selectedImage == null) {
      _showToast("Please select an image first", AppColors.error);
      return;
    }

    setState(() => _isProcessing = true);
    
    try {
      final String? decodedText = await _decodingService.decodeDataFromImage(
        _selectedImage!,
      );

      setState(() => _isProcessing = false);

      if (decodedText != null && decodedText.isNotEmpty) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DecodedResultPage(decodedText: decodedText),
            ),
          );
        }
      } else {
        _showToast("No hidden data found", AppColors.warning);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showToast("Error: $e", AppColors.error);
    }
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: AppColors.primaryText,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Extract Data',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedImage == null) _buildUploadArea(),
                  if (_selectedImage != null) ...[
                    _buildImagePreview(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryAccent,
                        ),
                        onPressed: _decodeData,
                        icon: const Icon(LucideIcons.unlock),
                        label: const Text('Extract Secret'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: AppColors.background.withValues(alpha: 0.9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SpinKitCubeGrid(
                      color: AppColors.secondaryAccent,
                      size: 60.0,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Analyzing pixels...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.secondaryAccent,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Extracting from 2nd LSB...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.secondaryAccent.withValues(alpha: 0.3),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              LucideIcons.imagePlus,
              size: 48,
              color: AppColors.secondaryAccent.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Select an encrypted image',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'PNG, JPG, JPEG, BMP',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Text(
              'We will scan the pixels for hidden data.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryAccent,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.file(
                  _selectedImage!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(LucideIcons.xCircle),
                  color: AppColors.error,
                  onPressed: _clearImage,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(LucideIcons.scan, color: AppColors.secondaryAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Ready to extract',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
