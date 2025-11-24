import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/i_character_listing_repository.dart';

class GetFavoriteCharacterIds {
  final ICharacterListingRepository repository;

  const GetFavoriteCharacterIds({required this.repository});

  Future<Either<Failure, List<int>>> call() {
    return repository.getFavoriteCharacterIds();
  }
}
