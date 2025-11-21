import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/local_storage_keys.dart';
import '../../../../core/data/local/local_storage_manager.dart';
import '../../../../core/data/remote/http_manager.dart';
import '../dtos/character_dto.dart';

abstract class ICharacterDataSource {
  Future<Either<void, CharacterDto>> getCharacterById(int id);

  Future<Either<void, bool>> toggleCharacterFavoriteStatus(int id);
}

class CharacterDataSource implements ICharacterDataSource {
  final HttpManager httpManager;
  final ILocalStorageCaller localStorageCaller;

  const CharacterDataSource({
    required this.httpManager,
    required this.localStorageCaller,
  });

  @override
  Future<Either<void, CharacterDto>> getCharacterById(int id) async {
    try {
      final response = await httpManager.restRequest(
        url: 'https://rickandmortyapi.com/api/character/$id',
        method: HttpMethods.get,
      );

      if (response.statusCode == 200) {
        final characterDto = CharacterDto.fromJson(response.data);
        final favoriteIds = await localStorageCaller.restoreData(
          table: LocalStorageBoxes.appBox,
          key: LocalStorageKeys.favoriteCharacterIds,
        );
        final result = favoriteIds.fold(
          (_) => <int>[],
          (ids) => List<int>.from(ids),
        );

        return Right(characterDto.copyWith(isFavorite: result.contains(id)));
      } else {
        return const Left(null);
      }
    } catch (e) {
      return const Left(null);
    }
  }

  @override
  Future<Either<void, bool>> toggleCharacterFavoriteStatus(int id) async {
    try {
      final favoriteIds = await localStorageCaller.restoreData(
        table: LocalStorageBoxes.appBox,
        key: LocalStorageKeys.favoriteCharacterIds,
      );

      final result = favoriteIds.fold(
        (_) => <int>[],
        (ids) => List<int>.from(ids),
      );

      if (result.contains(id)) {
        result.remove(id);
      } else {
        result.add(id);
      }

      await localStorageCaller.saveData(
        table: LocalStorageBoxes.appBox,
        key: LocalStorageKeys.favoriteCharacterIds,
        value: result,
      );

      return Right(result.contains(id));
    } catch (e) {
      return const Left(null);
    }
  }
}
