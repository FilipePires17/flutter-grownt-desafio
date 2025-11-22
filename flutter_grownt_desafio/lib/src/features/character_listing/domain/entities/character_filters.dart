class CharacterFilters {
  final int page;
  final String? name;
  final String? status;
  final String? species;
  final String? type;
  final String? gender;

  const CharacterFilters({
    required this.page,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
  });

  CharacterFilters copyWith({
    int? page,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
  }) {
    return CharacterFilters(
      page: page ?? this.page,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
    );
  }
}
