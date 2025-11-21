import '../../domain/entities/character.dart';

class CharacterDto extends Character {
  const CharacterDto({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.image,
    required super.episode,
    required super.origin,
    required super.location,
    super.isFavorite,
  });

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    return CharacterDto(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      image: json['image'],
      episode: List<String>.from(
        json['episode'],
      ).map((e) => e.toString().split('/').last).toList(),
      origin: json['origin']['name'],
      location: json['location']['name'],
      isFavorite: false,
    );
  }
}
