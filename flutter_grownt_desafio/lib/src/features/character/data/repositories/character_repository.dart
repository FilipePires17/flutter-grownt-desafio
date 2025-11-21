import 'package:fpdart/fpdart.dart';

import '../../../../core/platforms/network_info.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/i_character_repository.dart';
import '../datasources/character_datasource.dart';

class CharacterRepository implements ICharacterRepository {
  final ICharacterDataSource dataSource;
  final INetworkInfo networkInfo;

  const CharacterRepository({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<void, Character>> getCharacterById(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(null);
    }

    final result = await dataSource.getCharacterById(id);
    return result.map((dto) => dto);
  }

  @override
  Future<Either<void, bool>> toggleCharacterFavoriteStatus(int id) async {
    final result = await dataSource.toggleCharacterFavoriteStatus(id);
    return result;
  }
}
