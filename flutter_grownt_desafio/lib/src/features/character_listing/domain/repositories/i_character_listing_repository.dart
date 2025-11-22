import 'package:fpdart/fpdart.dart';

import '../entities/character_filters.dart';
import '../entities/character_listing.dart';

abstract class ICharacterListingRepository {
  Future<Either<void, CharacterListing>> getCharacters(
    CharacterFilters filters,
  );
  Future<Either<void, List<int>>> toggleCharacterFavoriteStatus(int id);
  Future<Either<void, List<int>>> getFavoriteCharacterIds();
}
