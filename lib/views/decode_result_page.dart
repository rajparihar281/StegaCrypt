import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_hiding_app/theme/app_colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DecodedResultPage extends StatefulWidget {
  final String decodedText;

  const DecodedResultPage({super.key, required this.decodedText});

  @override
  State<DecodedResultPage> createState() => _DecodedResultPageState();
}

class _DecodedResultPageState extends State<DecodedResultPage> {
  bool _isSecretVisible = false;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.decodedText));
    _showToast("Secret copied to clipboard", AppColors.success);
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: AppColors.background,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Secret Extracted',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 16),
              Text(
                'Data successfully recovered',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.success,
                    ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.fileText, color: AppColors.secondaryAccent, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Payload Data',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: AppColors.secondaryAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isSecretVisible = !_isSecretVisible;
                              });
                            },
                            icon: Icon(
                              _isSecretVisible ? LucideIcons.eyeOff : LucideIcons.eye,
                              color: AppColors.primaryText,
                              size: 16,
                            ),
                            label: Text(
                              _isSecretVisible ? 'Hide' : 'Show',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primaryText),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: AppColors.border),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.elevatedSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: SingleChildScrollView(
                            child: _isSecretVisible
                                ? SelectableText(
                                    widget.decodedText,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontFamily: 'monospace',
                                          height: 1.5,
                                        ),
                                  )
                                : Text(
                                    '•' * widget.decodedText.length,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontFamily: 'monospace',
                                          color: AppColors.mutedText,
                                          height: 1.5,
                                        ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Length: ${widget.decodedText.length} chars',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Integrity: Verified',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showToast("Export feature coming soon", AppColors.primaryAccent);
                      },
                      icon: const Icon(LucideIcons.download),
                      label: const Text('Export'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryAccent,
                      ),
                      onPressed: () => _copyToClipboard(context),
                      icon: const Icon(LucideIcons.copy),
                      label: const Text('Copy Secret'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
