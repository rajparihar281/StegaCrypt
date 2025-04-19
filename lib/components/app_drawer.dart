// ignore_for_file: deprecated_member_use

import 'package:data_hiding_app/views/instruction_page.dart';
import 'package:data_hiding_app/views/security_info_page.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF121212), Color(0xFF1E1E30), Color(0xFF252550)],
          ),
        ),
        child: Column(
          children: [
            // Drawer header with app logo
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.8),
                    Colors.deepPurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Circle avatar with app icon
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.enhanced_encryption,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'StegaCrypt',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // // Drawer items
            // _buildDrawerItem(
            //   context: context,
            //   icon: Icons.home,
            //   title: 'Option 1',
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Navigate to Option 1 page in the future
            //   },
            // ),

            // // Divider between items
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: Divider(
            //     color: Colors.purpleAccent,
            //     thickness: 1,
            //     height: 1,
            //   ),
            // ),

            // _buildDrawerItem(
            //   context: context,
            //   icon: Icons.settings,
            //   title: 'Option 2',
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Navigate to Option 2 page in the future
            //   },
            // ),

            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: Divider(
            //     color: Colors.purpleAccent,
            //     thickness: 1,
            //     height: 1,
            //   ),
            // ),

            _buildDrawerItem(
              context: context,
              icon: Icons.info,
              title: 'Security Details',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SecurityInfoPage()));
                // Navigate to Option 3 page in the future
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: Colors.purpleAccent,
                thickness: 1,
                height: 1,
              ),
            ),

            _buildDrawerItem(
              context: context,
              icon: Icons.help,
              title: 'How StegaCrpyt Works',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>InstructionsPage()));
                // Navigate to Option 4 page in the future
              },
            ),
   const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: Colors.purpleAccent,
                thickness: 1,
                height: 1,
              ),
            ),

            const Spacer(),

            // App version at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
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
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      hoverColor: Colors.purpleAccent.withOpacity(0.1),
      splashColor: Colors.purpleAccent.withOpacity(0.3),
    );
  }
}
