import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:stegacrypt/theme/app_colors.dart';

class DecodedResultPage extends StatefulWidget {
  final String decodedText;

  const DecodedResultPage({super.key, required this.decodedText});

  @override
  State<DecodedResultPage> createState() => _DecodedResultPageState();
}

class _DecodedResultPageState extends State<DecodedResultPage> {
  bool _isVisible = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.decodedText));
    Fluttertoast.showToast(
      msg: "Copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.cardBackground,
      textColor: AppColors.primaryText,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Extracted Secret'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildStatusBanner(context),
              const SizedBox(height: 20),
              Expanded(child: _buildSecretCard(context)),
              const SizedBox(height: 20),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.shieldCheck, color: AppColors.success, size: 18),
          const SizedBox(width: 10),
          Text(
            'Data successfully recovered',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            '${widget.decodedText.length} chars',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSecretCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payload',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.mutedText,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isVisible = !_isVisible),
                child: Row(
                  children: [
                    Icon(
                      _isVisible ? LucideIcons.eyeOff : LucideIcons.eye,
                      color: AppColors.secondaryText,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isVisible ? 'Hide' : 'Reveal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: SingleChildScrollView(
                child: _isVisible
                    ? SelectableText(
                        widget.decodedText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                              height: 1.6,
                              color: AppColors.primaryText,
                            ),
                      )
                    : Text(
                        '•' * widget.decodedText.length.clamp(0, 80),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.mutedText,
                              letterSpacing: 2,
                            ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Fluttertoast.showToast(
                msg: "Export coming soon",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.cardBackground,
                textColor: AppColors.primaryText,
              );
            },
            icon: const Icon(LucideIcons.download, size: 16),
            label: const Text('Export'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryAccent, foregroundColor: AppColors.primaryText),
            onPressed: _copyToClipboard,
            icon: const Icon(LucideIcons.copy, size: 16),
            label: const Text('Copy'),
          ),
        ),
      ],
    );
  }
}
