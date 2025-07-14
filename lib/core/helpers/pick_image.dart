// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// Future<void> _pickAndUploadImage(BuildContext context) async {
//   try {
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       if (context.mounted) {
//         context.read<UpdateInfoCubit>().uploadImage(File(image.path));
//       }
//     }
//   } catch (e) {
//     if (context.mounted) {
//       ShowSnackBar.showErrorSnackBar(context, "فشل اختيار الصورة: $e");
//     }
//   }
// }
