// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:data_hiding_app/components/custom_button.dart'
    show CustomButton;

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 18, 18, 18), Color(0xFF1E1E30), Color(0xFF252550)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'How It Works',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildSection(
                    title: "Data Hiding Process",
                    icon: Icons.enhanced_encryption,
                    color: Colors.greenAccent[700]!,
                    children: [
                      _buildStep(
                        step: "1",
                        title: "Select an Image",
                        description:
                            "Choose an image from your gallery or take a new photo with your camera.",
                        icon: Icons.image,
                      ),
                      _buildStep(
                        step: "2",
                        title: "Enter Secret Text",
                        description:
                            "Type the secret message you want to hide within the image.",
                        icon: Icons.text_fields,
                      ),
                      _buildStep(
                        step: "3",
                        title: "Encode Data",
                        description:
                            "Press the encode button to hide your message in the image using steganography.",
                        icon: Icons.lock,
                      ),
                      _buildStep(
                        step: "4",
                        title: "Save Result",
                        description:
                            "The app will save the encoded image to your device. The image looks normal but contains your hidden message.",
                        icon: Icons.save,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Decoding Instructions
                  _buildSection(
                    title: "Retrieving Hidden Data",
                    icon: Icons.no_encryption,
                    color: Colors.blueAccent,
                    children: [
                      _buildStep(
                        step: "1",
                        title: "Open Decode Page",
                        description:
                            "Navigate to the decode section of the app.",
                        icon: Icons.vpn_key,
                      ),
                      _buildStep(
                        step: "2",
                        title: "Select Encoded Image",
                        description:
                            "Choose the image containing the hidden message.",
                        icon: Icons.photo_library,
                      ),
                      _buildStep(
                        step: "3",
                        title: "Decode",
                        description:
                            "The app will extract and display the hidden message from the image.",
                        icon: Icons.visibility,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Technical Details
                  _buildExpandableSection(
                    title: "Technical Details",
                    icon: Icons.code,
                    color: Colors.purpleAccent,
                    content: const Text(
                      "This app uses steganography, a technique to hide information within ordinary files. "
                      "The process works by modifying the least significant bits (LSBs) of the pixel data in the image. "
                      "These tiny changes are imperceptible to the human eye but allow us to store your message within the image itself. "
                      "The data is embedded in a way that preserves the visual appearance of the image while securely "
                      "hiding your message. Only someone with this app can extract the hidden information.",
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Return to main button
                  CustomButton(
                    text: 'Start Hiding Data',
                    icon: Icons.arrow_forward,
                    backgroundColor: Colors.greenAccent[700],
                    onPressed: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }

  Widget _buildStep({
    required String step,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.white70, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget content,
  }) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white70,
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: content,
        ),
      ],
    );
  }
}
