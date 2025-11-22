import '../../domain/entities/character_filters.dart';

class CharacterFiltersDto extends CharacterFilters {
  const CharacterFiltersDto({
    required super.page,
    super.name,
    super.status,
    super.species,
    super.type,
    super.gender,
  });

  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {};

    params['page'] = page.toString();
    if (name != null) params['name'] = name!;
    if (status != null) params['status'] = status!;
    if (species != null) params['species'] = species!;
    if (type != null) params['type'] = type!;
    if (gender != null) params['gender'] = gender!;
    return params;
  }

  factory CharacterFiltersDto.fromDomain(CharacterFilters filters) {
    return CharacterFiltersDto(
      page: filters.page,
      name: filters.name,
      status: filters.status,
      species: filters.species,
      type: filters.type,
      gender: filters.gender,
    );
  }
}
