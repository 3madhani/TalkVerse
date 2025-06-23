import 'package:chitchat/core/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/colors/colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: (value) {
          if (widget.label == 'Email') {
            return Validator.validateEmail(value); // Fixed return statement
          } else if (widget.label == 'Password') {
            return Validator.validatePassword(value); // Fixed return statement
          }
          return null;
        },
        obscureText: widget.obscureText ? _obscureText : false,

        controller: widget.controller,
        decoration: InputDecoration(
          errorMaxLines: 2,
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(_obscureText ? Iconsax.eye_slash : Iconsax.eye),
                  )
                  : null,
          contentPadding: const EdgeInsets.all(16),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          label: Text(widget.label),
          prefixIcon: Icon(widget.prefixIcon),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // Initialize obscureText value
  }
}
