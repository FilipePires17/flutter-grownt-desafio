import 'package:fpdart/fpdart.dart';

import '../entities/character_listing.dart';

abstract class ICharacterListingRepository {
  Future<Either<void, CharacterListing>> getCharacters({int page = 1});
}
