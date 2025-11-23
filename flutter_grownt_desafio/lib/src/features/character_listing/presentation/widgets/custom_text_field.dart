import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.height = 48,
    this.prefixIcon,
    this.enabled,
  });

  final TextEditingController controller;
  final String? hintText;
  final double height;
  final Widget? prefixIcon;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.white),
          fillColor: AppColors.almostBlack,
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
