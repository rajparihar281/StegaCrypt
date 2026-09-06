import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:stegacrypt/theme/app_colors.dart';

class SecurityInfoPage extends StatelessWidget {
  const SecurityInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Security Info'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNoticeBanner(context),
              const SizedBox(height: 28),
              Text(
                'What you should know',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.mutedText,
                      letterSpacing: 0.4,
                    ),
              ),
              const SizedBox(height: 16),
              _buildPoint(
                context,
                icon: LucideIcons.eyeOff,
                title: 'Visual Imperceptibility',
                description: 'Hidden data is invisible to the naked eye but can be extracted by anyone with this app if they suspect data is present.',
              ),
              _buildPoint(
                context,
                icon: LucideIcons.lock,
                title: 'Security Through Obscurity',
                description: 'For highly sensitive data, consider pre-encrypting your message (e.g., AES/PGP) before hiding it with StegaCrypt.',
              ),
              _buildPoint(
                context,
                icon: LucideIcons.fileWarning,
                title: 'Data Fragility',
                description: 'Avoid compressing or editing encoded images. Sending via WhatsApp or similar apps will permanently destroy the hidden data.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoticeBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.shieldAlert, color: AppColors.warning, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Security Notice',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  'StegaCrypt uses steganography to hide information within images. Please understand the limitations before use.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoint(BuildContext context, {required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.secondaryText, size: 18),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
