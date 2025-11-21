import 'package:fpdart/fpdart.dart';

import '../repositories/i_character_repository.dart';

class ToggleCharacterFavoriteStatus {
  final ICharacterRepository repository;

  const ToggleCharacterFavoriteStatus({required this.repository});

  Future<Either<void, bool>> call(int id) {
    return repository.toggleCharacterFavoriteStatus(id);
  }
}
