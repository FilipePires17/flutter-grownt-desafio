import 'package:equatable/equatable.dart';
import '../../../character/domain/entities/character.dart';

class CharacterListing extends Equatable {
  final List<Character> characters;
  final List<int> favoriteCharacterIds;
  final int? totalItems;
  final int? nextPage;

  const CharacterListing({
    this.characters = const [],
    this.favoriteCharacterIds = const [],
    this.totalItems,
    this.nextPage,
  });

  CharacterListing copyWith({
    List<Character>? characters,
    List<int>? favoriteCharacterIds,
    int? totalItems,
    int? nextPage,
  }) {
    return CharacterListing(
      characters: characters ?? this.characters,
      favoriteCharacterIds: favoriteCharacterIds ?? this.favoriteCharacterIds,
      totalItems: totalItems ?? this.totalItems,
      nextPage: nextPage ?? this.nextPage,
    );
  }

  bool get hasReachedMax => characters.length >= (totalItems ?? 0);

  @override
  List<Object?> get props => [
    characters,
    favoriteCharacterIds,
    totalItems,
    nextPage,
  ];
}
