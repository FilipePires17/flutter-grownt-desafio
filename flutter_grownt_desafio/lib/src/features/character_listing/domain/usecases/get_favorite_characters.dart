import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/character_listing.dart';
import '../repositories/i_character_listing_repository.dart';

class GetFavoriteCharacters {
  final ICharacterListingRepository repository;

  const GetFavoriteCharacters({required this.repository});

  Future<Either<Failure, CharacterListing>> call() {
    return repository.getFavoriteCharacters();
  }
}
