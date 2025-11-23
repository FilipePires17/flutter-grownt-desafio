import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../character/domain/entities/character.dart';
import '../../../character/presentation/widgets/character_status_bar.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({super.key, required this.character, this.onFavorite});

  final Character character;
  final Function(int id)? onFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      shadowColor: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: character.image,
                fit: BoxFit.fill,
                errorWidget: (_, _, _) => const Icon(Icons.person),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    character.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 24,
                    color: character.isFavorite
                        ? AppColors.primary
                        : AppColors.lightGray,
                  ),
                  onPressed: () {
                    onFavorite?.call(character.id);
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 4,
                child: CharacterStatusBar(
                  characterStatusEnum: character.status,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  character.species,
                  style: TextStyle(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
