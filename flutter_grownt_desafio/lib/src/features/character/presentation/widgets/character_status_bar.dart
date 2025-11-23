import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/enums/character_status_enum.dart';

class CharacterStatusBar extends StatelessWidget {
  const CharacterStatusBar({super.key, required this.characterStatusEnum});

  final CharacterStatusEnum characterStatusEnum;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: characterStatusEnum.color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Text(
        characterStatusEnum.toString(),
        style: TextStyle(color: AppColors.white),
      ),
    );
  }
}
