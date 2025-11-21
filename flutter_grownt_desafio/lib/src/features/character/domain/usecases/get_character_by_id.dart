import 'package:fpdart/fpdart.dart';

import '../entities/character.dart';
import '../repositories/i_character_repository.dart';

class GetCharacterById {
  final ICharacterRepository repository;

  const GetCharacterById({required this.repository});

  Future<Either<void, Character>> call(int id) {
    return repository.getCharacterById(id);
  }
}
