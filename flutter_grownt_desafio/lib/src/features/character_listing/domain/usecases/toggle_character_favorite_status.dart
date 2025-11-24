import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/i_character_listing_repository.dart';

class ToggleCharacterFavoriteStatus {
  final ICharacterListingRepository repository;

  const ToggleCharacterFavoriteStatus({required this.repository});

  Future<Either<Failure, List<int>>> call(int id) {
    return repository.toggleCharacterFavoriteStatus(id);
  }
}
