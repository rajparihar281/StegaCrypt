import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:stegacrypt/theme/app_colors.dart';
import 'package:stegacrypt/views/instruction_page.dart';
import 'package:stegacrypt/views/security_info_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.secondaryBackground,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(LucideIcons.shield, color: AppColors.primaryAccent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'StegaCrypt',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'v1.0.0',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 8),
            _buildItem(context, icon: LucideIcons.layoutDashboard, title: 'Dashboard', onTap: () => Navigator.pop(context)),
            _buildItem(
              context,
              icon: LucideIcons.shieldAlert,
              title: 'Security Details',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityInfoPage()));
              },
            ),
            _buildItem(
              context,
              icon: LucideIcons.helpCircle,
              title: 'How It Works',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const InstructionsPage()));
              },
            ),
            const Spacer(),
            Divider(color: AppColors.border, height: 1),
            _buildItem(context, icon: LucideIcons.settings, title: 'Settings', onTap: () {}, muted: true),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool muted = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: muted ? AppColors.mutedText : AppColors.secondaryText, size: 20),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: muted ? AppColors.mutedText : AppColors.primaryText,
            ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
