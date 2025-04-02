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
            const Card(
              elevation: 3,
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(Iconsax.user),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Card(
              elevation: 3,
              child: ListTile(
                title: Text('Theme'),
                leading: Icon(Iconsax.color_swatch),
              ),
            ),

            Card(
              elevation: 3,
              child: ListTile(
                title: const Text('Dark Mode'),
                leading: const Icon(Iconsax.moon),
                trailing: Switch(value: true, onChanged: (value) {}),
              ),
            ),
            const Card(
              elevation: 3,
              child: ListTile(
                title: Text('Sign Out'),
                trailing: Icon(Iconsax.logout_1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
