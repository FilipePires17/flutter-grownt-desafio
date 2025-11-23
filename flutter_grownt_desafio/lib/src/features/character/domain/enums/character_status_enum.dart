import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

enum CharacterStatusEnum {
  alive('Alive', '🙂', Colors.green),
  dead('Dead', '☠️', Colors.red),
  unknown('Unknown', '🤷', AppColors.charcoalGrey);

  const CharacterStatusEnum(this.title, this.emoji, this.color);

  final String title;
  final String emoji;
  final Color color;

  @override
  String toString() => '$title $emoji';
}
