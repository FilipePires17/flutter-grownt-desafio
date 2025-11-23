import '../../domain/entities/character.dart';
import '../../domain/enums/character_status_enum.dart';

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
      status: CharacterStatusEnum.values.firstWhere(
        (s) => s.title.toLowerCase() == json['status'].toString().toLowerCase(),
      ),
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

  @override
  CharacterDto copyWith({
    int? id,
    String? name,
    CharacterStatusEnum? status,
    String? species,
    String? type,
    String? gender,
    String? image,
    List<String>? episode,
    String? origin,
    String? location,
    bool? isFavorite,
  }) {
    return CharacterDto(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      episode: episode ?? this.episode,
      origin: origin ?? this.origin,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
