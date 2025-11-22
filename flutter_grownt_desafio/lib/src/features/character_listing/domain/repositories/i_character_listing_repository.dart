import 'package:fpdart/fpdart.dart';

import '../entities/character_filters.dart';
import '../entities/character_listing.dart';

abstract class ICharacterListingRepository {
  Future<Either<String, CharacterListing>> getCharacters(
    CharacterFilters filters,
  );
  Future<Either<String, List<int>>> toggleCharacterFavoriteStatus(int id);
  Future<Either<String, List<int>>> getFavoriteCharacterIds();
  Future<Either<String, CharacterListing>> getFavoriteCharacters();
}
