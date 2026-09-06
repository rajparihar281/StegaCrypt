import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:stegacrypt/services/camera_service.dart';
import 'package:stegacrypt/services/encoding_service.dart';
import 'package:stegacrypt/theme/app_colors.dart';

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
    if (image != null) setState(() => _selectedImage = image);
  }

  Future<void> _takeImage() async {
    final File? image = await _cameraService.takeImageWithCamera();
    if (image != null) setState(() => _selectedImage = image);
  }

  void _clearImage() => setState(() => _selectedImage = null);

  Future<void> _encodeData() async {
    if (_selectedImage == null) {
      _showToast("Please select an image first", AppColors.error);
      return;
    }
    if (_textController.text.isEmpty) {
      _showToast("Please enter text to hide", AppColors.error);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final String? savedPath = await _encodingService.encodeDataIntoImage(
        _textController.text,
        _selectedImage!,
      );
      setState(() => _isProcessing = false);
      if (savedPath != null) {
        _showSuccessDialog();
      } else {
        _showToast("Failed to encode data", AppColors.error);
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(LucideIcons.shieldCheck, color: AppColors.success, size: 28),
              ),
              const SizedBox(height: 20),
              Text(
                'Data Hidden Successfully',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Your message has been embedded into the image using 2nd LSB steganography.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5, color: AppColors.secondaryText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildInfoRow(context, 'Method', '2nd LSB'),
              const SizedBox(height: 8),
              _buildInfoRow(context, 'Status', 'Verified', valueColor: AppColors.success),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedImage = null;
                      _textController.clear();
                    });
                  },
                  child: const Text('Hide Another Message'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: valueColor ?? AppColors.primaryAccent,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hide Data'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedImage == null) _buildUploadArea(),
                  if (_selectedImage != null) ...[
                    _buildImagePreview(),
                    const SizedBox(height: 20),
                    _buildPipelineCard(context),
                    const SizedBox(height: 20),
                    _buildInputArea(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _encodeData,
                        icon: const Icon(LucideIcons.lock, size: 18),
                        label: const Text('Embed Secret'),
                      ),
                    ),
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
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.imagePlus, size: 24, color: AppColors.primaryAccent),
                ),
                const SizedBox(height: 16),
                Text('Select an image', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 6),
                Text('PNG, JPG, JPEG, BMP', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _takeImage,
            icon: const Icon(LucideIcons.camera, size: 18),
            label: const Text('Use Camera'),
          ),
        ),
      ],
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
                child: Image.file(_selectedImage!, width: double.infinity, height: 200, fit: BoxFit.cover),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Carrier image selected', style: Theme.of(context).textTheme.bodySmall),
                Text('Ready', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPipelineStep(context, 'Input', LucideIcons.fileText),
          const Icon(LucideIcons.arrowRight, color: AppColors.mutedText, size: 14),
          _buildPipelineStep(context, 'Encrypt', LucideIcons.lock),
          const Icon(LucideIcons.arrowRight, color: AppColors.mutedText, size: 14),
          _buildPipelineStep(context, '2nd LSB', LucideIcons.binary),
          const Icon(LucideIcons.arrowRight, color: AppColors.mutedText, size: 14),
          _buildPipelineStep(context, 'Output', LucideIcons.image),
        ],
      ),
    );
  }

  Widget _buildPipelineStep(BuildContext context, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondaryText, size: 18),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildInputArea() {
    return TextField(
      controller: _textController,
      maxLines: 5,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Enter your secret message...',
        hintStyle: Theme.of(context).textTheme.bodySmall,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryAccent),
        ),
        contentPadding: const EdgeInsets.all(16),
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
            const SpinKitCubeGrid(color: AppColors.primaryAccent, size: 48.0),
            const SizedBox(height: 28),
            Text('Embedding data...', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryAccent)),
            const SizedBox(height: 6),
            Text('Writing to 2nd LSB layer', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
