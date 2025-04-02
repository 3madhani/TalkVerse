import 'package:chitchat/features/auth/presentation/views/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  bool enableName = false;
  bool enableAbout = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(radius: 70),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Iconsax.edit),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: TextField(
                    enabled: enableName,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  leading: const Icon(Iconsax.user_octagon),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.edit),
                    onPressed: () {
                      setState(() {
                        enableName = !enableName;
                      });
                    },
                  ),
                ),
              ),
              Card(
                elevation: 3,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: TextField(
                    enabled: enableAbout,
                    controller: aboutController,
                    decoration: const InputDecoration(
                      labelText: 'About',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  leading: const Icon(Iconsax.information),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.edit),
                    onPressed: () {
                      setState(() {
                        enableAbout = !enableAbout;
                      });
                    },
                  ),
                ),
              ),
              Card(
                elevation: 3,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text('Email'),
                  subtitle: const Text('qk2Bq@example.com'),
                  leading: const Icon(Iconsax.direct),
                ),
              ),
              Card(
                elevation: 3,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text('Join Date'),
                  subtitle: const Text('2023-10-01'),
                  leading: const Icon(Iconsax.calendar_1),
                ),
              ),
              const SizedBox(height: 40),
              CustomElevatedButton(
                label: 'Save',
                onPressed: () {},

                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    nameController.text = 'John Doe';
    aboutController.text =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
    super.initState();
  }
}
