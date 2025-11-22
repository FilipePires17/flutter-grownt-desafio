import '../../../character/data/dtos/character_dto.dart';
import '../../domain/entities/character_listing.dart';

class CharacterListingDto extends CharacterListing {
  const CharacterListingDto({
    required super.characters,
    super.favoriteCharacterIds,
    super.totalItems,
    super.nextPage,
  });

  factory CharacterListingDto.fromJson(Map<String, dynamic> json) {
    final charactersJson = json['results'] as List<dynamic>? ?? [];
    final characters = charactersJson
        .map(
          (characterJson) =>
              CharacterDto.fromJson(characterJson as Map<String, dynamic>),
        )
        .toList();

    final totalItems = json['info'] != null
        ? json['info']['count'] as int?
        : null;
    final nextPageUrl = json['info'] != null
        ? json['info']['next'] as String?
        : null;
    int? nextPage;
    if (nextPageUrl != null) {
      final uri = Uri.parse(nextPageUrl);
      nextPage = int.tryParse(uri.queryParameters['page'] ?? '');
    }

    return CharacterListingDto(
      characters: characters,
      totalItems: totalItems,
      nextPage: nextPage,
    );
  }

  factory CharacterListingDto.fromJsonList(List<dynamic> jsonList) {
    final characters = jsonList
        .map(
          (characterJson) =>
              CharacterDto.fromJson(characterJson as Map<String, dynamic>),
        )
        .toList();

    return CharacterListingDto(characters: characters);
  }
}
