import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.title, required this.info});

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(info, style: TextStyle(color: AppColors.secondary, fontSize: 20)),
      ],
    );
  }
}
