import 'package:chitchat/features/settings/presentation/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              minVerticalPadding: 40,
              title: const Text('Name'),
              leading: const CircleAvatar(radius: 30),
              trailing: IconButton(
                icon: const Icon(Iconsax.scan_barcode),
                onPressed: () {},
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Profile'),
                leading: const Icon(Iconsax.user),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Theme'),
                leading: const Icon(Iconsax.color_swatch),
              ),
            ),

            Card(
              elevation: 3,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Dark Mode'),
                leading: const Icon(Iconsax.moon),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
            ),
            Card(
              elevation: 3,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Sign Out'),
                trailing: const Icon(Iconsax.logout_1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
