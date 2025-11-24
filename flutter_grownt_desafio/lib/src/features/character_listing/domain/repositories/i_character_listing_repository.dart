import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/character_filters.dart';
import '../entities/character_listing.dart';

abstract class ICharacterListingRepository {
  Future<Either<Failure, CharacterListing>> getCharacters(
    CharacterFilters filters,
  );
  Future<Either<Failure, List<int>>> toggleCharacterFavoriteStatus(int id);
  Future<Either<Failure, List<int>>> getFavoriteCharacterIds();
  Future<Either<Failure, CharacterListing>> getFavoriteCharacters();
}
