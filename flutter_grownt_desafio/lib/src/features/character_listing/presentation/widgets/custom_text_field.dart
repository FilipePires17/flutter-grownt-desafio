import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.height = 48,
    this.enabled,
  });

  final TextEditingController controller;
  final String? hintText;
  final double height;
  final bool? enabled;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextField(
        enabled: widget.enabled,
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: AppColors.secondary),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColors.white),
          fillColor: widget.enabled ?? false
              ? AppColors.almostBlack
              : AppColors.gray,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.secondary),
          suffixIcon: widget.controller.text != ''
              ? GestureDetector(
                  onTap: () {
                    widget.controller.text = '';
                    setState(() {});
                  },
                  child: const Icon(Icons.close, color: AppColors.secondary),
                )
              : null,
        ),
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}
