import 'package:data_hiding_app/views/instruction_page.dart';
import 'package:data_hiding_app/views/security_info_page.dart';
import 'package:flutter/material.dart';
import 'package:data_hiding_app/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.shield,
                      color: AppColors.primaryAccent,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'StegaCrypt',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Secure Vault',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryAccent,
                              letterSpacing: 1.5,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDrawerItem(
              context: context,
              icon: LucideIcons.layoutDashboard,
              title: 'Dashboard',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: LucideIcons.shieldAlert,
              title: 'Security Details',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecurityInfoPage()),
                );
              },
            ),
            _buildDrawerItem(
              context: context,
              icon: LucideIcons.helpCircle,
              title: 'How It Works',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InstructionsPage()),
                );
              },
            ),
            const Spacer(),
            const Divider(color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const Icon(LucideIcons.settings, color: AppColors.mutedText, size: 20),
                  const SizedBox(width: 16),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.mutedText,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedText.withValues(alpha: 0.5),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryText, size: 24),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: AppColors.primaryAccent.withValues(alpha: 0.1),
    );
  }
}
