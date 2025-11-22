import 'package:fpdart/fpdart.dart';

import '../repositories/i_character_listing_repository.dart';

class GetFavoriteCharacterIds {
  final ICharacterListingRepository repository;

  const GetFavoriteCharacterIds({required this.repository});

  Future<Either<String, List<int>>> call() {
    return repository.getFavoriteCharacterIds();
  }
}
