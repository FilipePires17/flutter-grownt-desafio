import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/local_storage_keys.dart';
import '../../../../core/data/local/local_storage_manager.dart';
import '../../../../core/data/remote/http_manager.dart';
import '../dtos/character_filters_dto.dart';
import '../dtos/character_listing_dto.dart';

abstract class ICharacterListingDataSource {
  Future<Either<void, CharacterListingDto>> getCharacters(
    CharacterFiltersDto filters,
  );

  Future<Either<void, List<int>>> toggleCharacterFavoriteStatus(int id);

  Future<Either<void, List<int>>> getFavoriteCharacterIds();
}

class CharacterListingDatasource implements ICharacterListingDataSource {
  final HttpManager httpManager;
  final ILocalStorageCaller localStorageCaller;

  const CharacterListingDatasource({
    required this.httpManager,
    required this.localStorageCaller,
  });

  @override
  Future<Either<void, CharacterListingDto>> getCharacters(
    CharacterFiltersDto filters,
  ) async {
    try {
      final response = await httpManager.restRequest(
        url: 'https://rickandmortyapi.com/api/character',
        method: HttpMethods.get,
        parameters: filters.toQueryParameters(),
      );

      final characterListingDto = CharacterListingDto.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(characterListingDto);
    } catch (e) {
      return const Left(null);
    }
  }

  @override
  Future<Either<void, List<int>>> getFavoriteCharacterIds() async {
    try {
      final favoriteIds = await localStorageCaller.restoreData(
        table: LocalStorageBoxes.appBox,
        key: LocalStorageKeys.favoriteCharacterIds,
      );

      final result = favoriteIds.fold(
        (_) => <int>[],
        (ids) => List<int>.from(ids),
      );

      return Right(result);
    } catch (e) {
      return const Left(null);
    }
  }

  @override
  Future<Either<void, List<int>>> toggleCharacterFavoriteStatus(int id) async {
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

      return Right(result);
    } catch (e) {
      return const Left(null);
    }
  }
}
