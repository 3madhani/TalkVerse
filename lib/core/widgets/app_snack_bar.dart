import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void showError(BuildContext context, String message) {
    _show(
      context,
      title: 'Error!',
      message: message,
      contentType: ContentType.failure,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      title: 'Success!',
      message: message,
      contentType: ContentType.success,
    );
  }

  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 3),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
