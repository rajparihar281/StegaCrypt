import 'package:flutter/material.dart';

class SecurityInfoPage extends StatelessWidget {
  const SecurityInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Security Info',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor:  Colors.deepPurple,
      ),
      backgroundColor:const Color.fromARGB(255, 15, 7, 16),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBulletPoint(
              "The hidden data is invisible to the naked eye but can be extracted by anyone with this app.",
            ),
            _buildBulletPoint(
              "This method provides basic security through obscurity - most people won't know there's hidden data.",
            ),
            _buildBulletPoint(
              "For additional security, consider encrypting your message before hiding it.",
            ),
            _buildBulletPoint(
              "Avoid compressing or editing the encoded images as this may corrupt or destroy the hidden data.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•  ",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color.fromARGB(221, 255, 255, 255), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
