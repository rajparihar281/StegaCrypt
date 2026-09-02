import 'package:flutter/material.dart';
import 'package:data_hiding_app/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'How StegaCrypt Works',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context,
                title: "The Quantum Vault Process",
                icon: LucideIcons.binary,
                color: AppColors.primaryAccent,
                children: [
                  _buildStep(
                    context,
                    step: "01",
                    title: "Image Selection",
                    description: "Select an ordinary image to act as your secure vault.",
                    icon: LucideIcons.image,
                  ),
                  _buildStep(
                    context,
                    step: "02",
                    title: "Payload Construction",
                    description: "Input the secret data you wish to encrypt and hide.",
                    icon: LucideIcons.fileText,
                  ),
                  _buildStep(
                    context,
                    step: "03",
                    title: "2nd LSB Embedding",
                    description: "Data is embedded into the 2nd Least Significant Bit of the image pixels, making it visually imperceptible.",
                    icon: LucideIcons.lock,
                  ),
                  _buildStep(
                    context,
                    step: "04",
                    title: "Secure Output",
                    description: "The steganographic image is generated and secured for transmission.",
                    icon: LucideIcons.download,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSection(
                context,
                title: "Data Extraction",
                icon: LucideIcons.scan,
                color: AppColors.secondaryAccent,
                children: [
                  _buildStep(
                    context,
                    step: "01",
                    title: "Scan Image",
                    description: "Load the steganographic image into the extraction layer.",
                    icon: LucideIcons.scanLine,
                  ),
                  _buildStep(
                    context,
                    step: "02",
                    title: "Recover Payload",
                    description: "The 2nd LSB data is reconstructed back into the original payload.",
                    icon: LucideIcons.unlock,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildExpandableSection(
                context,
                title: "Technical Overview: 2nd LSB",
                icon: LucideIcons.cpu,
                color: AppColors.success,
                content: Text(
                  "By altering the second least significant bit of the pixel channels, StegaCrypt achieves a perfect balance between payload capacity and visual integrity. "
                  "The changes are deeply embedded at the binary level, avoiding detection by standard forensic tools while ensuring the image looks completely ordinary to the human eye.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.arrowRight),
                  label: const Text('Start Hiding Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String step,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedText,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.primaryText, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          iconColor: AppColors.primaryText,
          collapsedIconColor: AppColors.mutedText,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}
