import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../manager/theme_view_model.dart';

class DarkModeTile extends StatelessWidget {
  const DarkModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ThemeViewModel>(context);

    return Card(
      elevation: 3,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Dark Mode'),
        leading: const Icon(Iconsax.moon),
        trailing: Switch(
          value: viewModel.isDarkMode,
          onChanged: viewModel.toggleDarkMode,
        ),
      ),
    );
  }
}
