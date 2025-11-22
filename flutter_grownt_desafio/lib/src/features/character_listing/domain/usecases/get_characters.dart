import 'package:fpdart/fpdart.dart';

import '../entities/character_filters.dart';
import '../entities/character_listing.dart';
import '../repositories/i_character_listing_repository.dart';

class GetCharacters {
  final ICharacterListingRepository repository;

  GetCharacters({required this.repository});

  Future<Either<String, CharacterListing>> call(CharacterFilters filters) {
    return repository.getCharacters(filters);
  }
}
