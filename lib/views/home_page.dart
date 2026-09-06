import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:stegacrypt/components/app_drawer.dart';
import 'package:stegacrypt/theme/app_colors.dart';
import 'package:stegacrypt/views/decode_page.dart';
import 'package:stegacrypt/views/encode_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.secondaryText),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.shield, color: AppColors.primaryAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              'StegaCrypt',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'What would you\nlike to do?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Embed or extract hidden data from images.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 36),
              _buildActionCard(
                context,
                title: 'Hide Data',
                description: 'Embed a secret message inside any image using 2nd LSB steganography.',
                icon: LucideIcons.lock,
                accentColor: AppColors.primaryAccent,
                tag: 'ENCODE',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EncodePage()),
                ),
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                title: 'Extract Data',
                description: 'Recover hidden data from a steganographic image.',
                icon: LucideIcons.unlock,
                accentColor: AppColors.secondaryAccent,
                tag: 'DECODE',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DecodePage()),
                ),
              ),
              const Spacer(),
              _buildStatusBar(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
    required String tag,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: accentColor.withValues(alpha: 0.06),
        highlightColor: accentColor.withValues(alpha: 0.04),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryText,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(LucideIcons.chevronRight, color: AppColors.mutedText, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'All systems operational',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.secondaryText,
                ),
          ),
          const Spacer(),
          Text(
            '2nd LSB · AES',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedText,
                  letterSpacing: 0.3,
                ),
          ),
        ],
      ),
    );
  }
}
