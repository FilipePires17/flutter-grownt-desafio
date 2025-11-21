import 'package:fpdart/fpdart.dart';

import '../entities/character.dart';

abstract class ICharacterRepository {
  Future<Either<void, Character>> getCharacterById(int id);

  Future<Either<void, bool>> toggleCharacterFavoriteStatus(int id);
}
