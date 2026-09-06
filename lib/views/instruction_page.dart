import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:stegacrypt/theme/app_colors.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('How It Works'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel(context, 'ENCODING'),
              const SizedBox(height: 12),
              _buildStepsCard(context, [
                _StepData('01', 'Select Image', 'Choose any PNG, JPG, or BMP image as your carrier.', LucideIcons.image),
                _StepData('02', 'Enter Payload', 'Type the secret message you want to embed.', LucideIcons.fileText),
                _StepData('03', '2nd LSB Embedding', 'Data is written into the 2nd least significant bit of each pixel channel.', LucideIcons.binary),
                _StepData('04', 'Save Output', 'The encoded image is saved — visually identical to the original.', LucideIcons.download),
              ]),
              const SizedBox(height: 28),
              _buildSectionLabel(context, 'DECODING'),
              const SizedBox(height: 12),
              _buildStepsCard(context, [
                _StepData('01', 'Load Image', 'Select the steganographic image to scan.', LucideIcons.scanLine),
                _StepData('02', 'Extract Payload', 'The 2nd LSB data is reconstructed into the original message.', LucideIcons.unlock),
              ]),
              const SizedBox(height: 28),
              _buildTechNote(context),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.arrowLeft, size: 16),
                  label: const Text('Back to App'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.mutedText,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildStepsCard(BuildContext context, List<_StepData> steps) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final isLast = entry.key == steps.length - 1;
          return _buildStep(context, entry.value, isLast: isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildStep(BuildContext context, _StepData data, {required bool isLast}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    data.step,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryAccent,
                          fontSize: 10,
                        ),
                  ),
                ),
              ),
              if (!isLast) ...[
                const SizedBox(height: 4),
                Container(width: 1, height: 16, color: AppColors.border),
              ],
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(data.icon, color: AppColors.secondaryText, size: 15),
                    const SizedBox(width: 6),
                    Text(data.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(data.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.cpu, color: AppColors.primaryAccent, size: 16),
              const SizedBox(width: 8),
              Text(
                'Technical Note',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'By altering the second least significant bit of each pixel channel, StegaCrypt achieves a balance between payload capacity and visual integrity. '
            'Changes are imperceptible to the human eye and avoid detection by standard image analysis tools.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _StepData {
  final String step;
  final String title;
  final String description;
  final IconData icon;
  const _StepData(this.step, this.title, this.description, this.icon);
}
