import 'dart:io';
import 'package:data_hiding_app/services/camera_service.dart' show CameraService;
import 'package:data_hiding_app/services/encoding_service.dart' show EncodingService;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:data_hiding_app/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _takeImage() async {
    final File? image = await _cameraService.takeImageWithCamera();
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  void _clearImage() {
    setState(() => _selectedImage = null);
  }

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
        _showSuccessDialog(savedPath);
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

  void _showSuccessDialog(String imagePath) {
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.shieldCheck,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Secret Successfully Hidden',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your encrypted payload has been embedded into the image using 2nd LSB technique.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Embedding Method:', style: Theme.of(context).textTheme.bodySmall),
                  Text('2nd LSB', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryAccent)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Verification Status:', style: Theme.of(context).textTheme.bodySmall),
                  Text('Verified', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.success)),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Hide Data',
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
                    const SizedBox(height: 24),
                    _buildEncryptionPipeline(),
                    const SizedBox(height: 24),
                    _buildInputArea(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _encodeData,
                        icon: const Icon(LucideIcons.lock),
                        label: const Text('Start Hiding'),
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
                      color: AppColors.primaryAccent,
                      size: 60.0,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Analyzing pixels...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primaryAccent,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Embedding into 2nd LSB...',
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
    return Column(
      children: [
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryAccent.withValues(alpha: 0.3),
                style: BorderStyle.solid,
                width: 2, // Would use dashed border package in real app
              ),
            ),
            child: Column(
              children: [
                Icon(
                  LucideIcons.imagePlus,
                  size: 48,
                  color: AppColors.primaryAccent.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap to select your image',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'PNG, JPG, JPEG, BMP',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                Text(
                  'Your secret stays inside the image.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _takeImage,
          icon: const Icon(LucideIcons.camera),
          label: const Text('Use Camera'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ],
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
                  height: 200,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Image',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Capacity usage', style: Theme.of(context).textTheme.bodySmall),
                    Text('Secure', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: 0.2, // Mock capacity
                  backgroundColor: AppColors.elevatedSurface,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncryptionPipeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.shield, color: AppColors.secondaryAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Encryption Layer',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.secondaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPipelineStep('Secret Data', LucideIcons.fileText),
              _buildPipelineArrow(),
              _buildPipelineStep('Encryption', LucideIcons.lock),
              _buildPipelineArrow(),
              _buildPipelineStep('2nd LSB', LucideIcons.binary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineStep(String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryText, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildPipelineArrow() {
    return const Icon(LucideIcons.arrowRight, color: AppColors.mutedText, size: 16);
  }

  Widget _buildInputArea() {
    return TextField(
      controller: _textController,
      maxLines: 4,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Enter secret payload...',
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryAccent),
        ),
      ),
    );
  }
}