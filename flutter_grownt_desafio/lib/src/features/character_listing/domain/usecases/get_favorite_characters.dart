import 'package:fpdart/fpdart.dart';

import '../entities/character_listing.dart';
import '../repositories/i_character_listing_repository.dart';

class GetFavoriteCharacters {
  final ICharacterListingRepository repository;

  const GetFavoriteCharacters({required this.repository});

  Future<Either<String, CharacterListing>> call() {
    return repository.getFavoriteCharacters();
  }
}
