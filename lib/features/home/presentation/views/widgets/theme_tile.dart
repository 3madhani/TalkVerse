import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../settings/presentation/view_model/settings_view_model.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);

    return Card(
      elevation: 3,
      child: ListTile(
        onTap: () => _showColorPicker(context, viewModel),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Theme'),
        leading: const Icon(Iconsax.color_swatch),
      ),
    );
  }

  void _showColorPicker(BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: viewModel.selectedColor,
                onColorChanged: viewModel.changeThemeColor,
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }
}
