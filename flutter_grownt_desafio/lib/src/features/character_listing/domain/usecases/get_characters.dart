import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/character_filters.dart';
import '../entities/character_listing.dart';
import '../repositories/i_character_listing_repository.dart';

class GetCharacters {
  final ICharacterListingRepository repository;

  GetCharacters({required this.repository});

  Future<Either<Failure, CharacterListing>> call(CharacterFilters filters) {
    return repository.getCharacters(filters);
  }
}
