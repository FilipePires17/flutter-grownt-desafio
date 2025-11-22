import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.height = 48,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String? hintText;
  final double height;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          fillColor: AppColors.charcoalGrey,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          prefixIcon: prefixIcon,
        ),
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}
