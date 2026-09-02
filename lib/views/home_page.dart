import 'package:data_hiding_app/components/app_drawer.dart' show AppDrawer;
import 'package:data_hiding_app/views/decode_page.dart' show DecodePage;
import 'package:data_hiding_app/views/encode_page.dart' show EncodePage;
import 'package:flutter/material.dart';
import 'package:data_hiding_app/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.shield, color: AppColors.primaryAccent, size: 24),
            const SizedBox(width: 8),
            Text(
              'StegaCrypt',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              AppColors.secondaryBackground,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Hide. Encrypt. Protect.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryAccent,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: 48),
                Expanded(
                  child: ListView(
                    children: [
                      _buildActionCard(
                        context,
                        title: 'Hide Data',
                        description: 'Securely embed secret data inside an image.',
                        icon: LucideIcons.lock,
                        primaryColor: AppColors.primaryAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EncodePage(),
                            ),
                          );
                        },
                        ctaText: 'Start Hiding',
                      ),
                      const SizedBox(height: 24),
                      _buildActionCard(
                        context,
                        title: 'Extract Data',
                        description: 'Recover hidden data from a steganographic image.',
                        icon: LucideIcons.unlock,
                        primaryColor: AppColors.secondaryAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DecodePage(),
                            ),
                          );
                        },
                        ctaText: 'Extract Secret',
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    required Color primaryColor,
    required VoidCallback onTap,
    required String ctaText,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(icon, color: primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Icon(
                  LucideIcons.image,
                  color: AppColors.mutedText.withValues(alpha: 0.5),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ctaText,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Icon(
                  LucideIcons.arrowRight,
                  color: primaryColor,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
