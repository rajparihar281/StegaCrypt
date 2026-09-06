// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final File? image;
  final VoidCallback onClear;
  final double height;
  final BoxFit fit;
  final Color placeholderColor;
  final Color closeButtonColor;

  const ImagePreview({
    super.key,
    required this.image,
    required this.onClear,
    this.height = 250,
    this.fit = BoxFit.contain,
    this.placeholderColor = Colors.grey,
    this.closeButtonColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: image == null ? _buildPlaceholder() : _buildImageWithCloseButton(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      key: const ValueKey('placeholder'),
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 60, color: Colors.grey[500]),
            const SizedBox(height: 10),
            Text(
              'No image selected',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithCloseButton() {
    return Stack(
      key: const ValueKey('image'),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(
              image!,
              width: double.infinity,
              height: height,
              fit: fit,
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: GestureDetector(
            onTap: onClear,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: closeButtonColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
