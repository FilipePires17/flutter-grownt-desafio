import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({super.key, required this.isFavorite});

  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isFavorite ? Icons.favorite : Icons.favorite_border,
      size: 24,
      color: isFavorite ? AppColors.secondary : AppColors.lightGray,
    );
  }
}
