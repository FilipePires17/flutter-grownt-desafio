import 'package:flutter/material.dart';

import '../../../../core/constants/routes.dart';
import '../../domain/entities/character_listing.dart';
import 'character_card.dart';

class CharacterList extends StatelessWidget {
  const CharacterList({
    super.key,
    required this.characterListing,
    this.onFavorite,
  });

  final CharacterListing characterListing;
  final Function(int id)? onFavorite;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return index < characterListing.characters.length
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.character,
                      arguments: index,
                    ),
                    child: CharacterCard(
                      character: characterListing.characters[index],
                      onFavorite: onFavorite,
                    ),
                  ),
                )
              : const SizedBox(
                  height: 48,
                  child: Center(child: CircularProgressIndicator()),
                );
        },
        childCount: characterListing.hasReachedMax
            ? characterListing.characters.length
            : characterListing.characters.length + 1,
      ),
    );
  }
}
