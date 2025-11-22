import 'package:fpdart/fpdart.dart';

import '../repositories/i_character_listing_repository.dart';

class ToggleCharacterFavoriteStatus {
  final ICharacterListingRepository repository;

  const ToggleCharacterFavoriteStatus({required this.repository});

  Future<Either<String, List<int>>> call(int id) {
    return repository.toggleCharacterFavoriteStatus(id);
  }
}
