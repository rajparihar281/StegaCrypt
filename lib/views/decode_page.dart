import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:stegacrypt/services/camera_service.dart';
import 'package:stegacrypt/services/decoding_service.dart';
import 'package:stegacrypt/theme/app_colors.dart';
import 'package:stegacrypt/views/decode_result_page.dart';

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
    if (image != null) setState(() => _selectedImage = image);
  }

  void _clearImage() => setState(() => _selectedImage = null);

  Future<void> _decodeData() async {
    if (_selectedImage == null) {
      _showToast("Please select an image first", AppColors.error);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final String? decodedText = await _decodingService.decodeDataFromImage(_selectedImage!);
      setState(() => _isProcessing = false);

      if (decodedText != null && decodedText.isNotEmpty) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DecodedResultPage(decodedText: decodedText)),
          );
        }
      } else {
        _showToast("No hidden data found in this image", AppColors.warning);
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
        title: const Text('Extract Data'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedImage == null) ...[
                    Expanded(child: _buildUploadArea()),
                  ] else ...[
                    _buildImagePreview(),
                    const SizedBox(height: 20),
                    _buildScanInfo(context),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryAccent,
                          foregroundColor: AppColors.primaryText,
                        ),
                        onPressed: _decodeData,
                        icon: const Icon(LucideIcons.scanLine, size: 18),
                        label: const Text('Extract Secret'),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ],
              ),
            ),
          ),
          if (_isProcessing) _buildLoader(context),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.imagePlus, size: 24, color: AppColors.secondaryAccent),
            ),
            const SizedBox(height: 16),
            Text('Select a steganographic image', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Text('PNG, JPG, JPEG, BMP', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 20),
            Text(
              'Tap anywhere to browse',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.secondaryAccent),
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: Image.file(_selectedImage!, width: double.infinity, height: 260, fit: BoxFit.cover),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _clearImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(LucideIcons.x, color: AppColors.secondaryText, size: 16),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(LucideIcons.scan, color: AppColors.secondaryAccent, size: 16),
                const SizedBox(width: 8),
                Text('Ready to scan', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.secondaryAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.info, color: AppColors.mutedText, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Scanning the 2nd LSB layer of each pixel channel for hidden data.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader(BuildContext context) {
    return Container(
      color: AppColors.background.withValues(alpha: 0.92),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitCubeGrid(color: AppColors.secondaryAccent, size: 48.0),
            const SizedBox(height: 28),
            Text('Scanning pixels...', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondaryAccent)),
            const SizedBox(height: 6),
            Text('Reading 2nd LSB layer', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
