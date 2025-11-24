import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/local_storage_keys.dart';
import '../../../../core/data/local/local_storage_manager.dart';
import '../../../../core/data/remote/http_manager.dart';
import '../../../../core/error/failure.dart';
import '../dtos/character_filters_dto.dart';
import '../dtos/character_listing_dto.dart';

abstract class ICharacterListingDataSource {
  Future<Either<Failure, CharacterListingDto>> getCharacters(
    CharacterFiltersDto filters,
  );

  Future<Either<Failure, List<int>>> toggleCharacterFavoriteStatus(int id);

  Future<Either<Failure, List<int>>> getFavoriteCharacterIds();

  Future<Either<Failure, CharacterListingDto>> getFavoriteCharacters();
}

class CharacterListingDatasource implements ICharacterListingDataSource {
  final HttpManager httpManager;
  final ILocalStorageCaller localStorageCaller;

  const CharacterListingDatasource({
    required this.httpManager,
    required this.localStorageCaller,
  });

  @override
  Future<Either<Failure, CharacterListingDto>> getCharacters(
    CharacterFiltersDto filters,
  ) async {
    try {
      final response = await httpManager.restRequest(
        url: 'https://rickandmortyapi.com/api/character',
        method: HttpMethods.get,
        parameters: filters.toQueryParameters(),
      );

      if (response.statusCode != 200) {
        return Left(
          ServerFailure(
            response.statusMessage ?? 'Server Error',
            statusCode: response.statusCode,
          ),
        );
      }

      try {
        final characterListingDto = CharacterListingDto.fromJson(
          response.data as Map<String, dynamic>,
        );
        return Right(characterListingDto);
      } catch (e) {
        return Left(DataParsingFailure('Error parsing server data'));
      }
    } catch (e) {
      return Left(NetworkFailure('Unknown Error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getFavoriteCharacterIds() async {
    try {
      final favoriteIds = await localStorageCaller.restoreData(
        table: LocalStorageBoxes.appBox,
        key: LocalStorageKeys.favoriteCharacterIds,
      );

      final result = favoriteIds.fold<Either<Failure, List<int>>>(
        (_) => Left(
          LocalStorageFailure('Not able to retrieve favorite character IDs'),
        ),
        (ids) => Right(List<int>.from(ids)),
      );

      return result;
    } catch (e) {
      return Left(LocalStorageFailure('Unknown Error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> toggleCharacterFavoriteStatus(
    int id,
  ) async {
    try {
      final favoriteIdsResult = await getFavoriteCharacterIds();

      List<int> updatedFavoriteIds = [];

      final result = favoriteIdsResult.fold<Either<Failure, List<int>>>(
        (failure) => Left(failure),
        (ids) {
          List<int> res = List<int>.from(ids);
          if (res.contains(id)) {
            res.remove(id);
          } else {
            res.add(id);
          }
          updatedFavoriteIds = res;

          return Right(res);
        },
      );

      if (result.isRight()) {
        await localStorageCaller.saveData(
          table: LocalStorageBoxes.appBox,
          key: LocalStorageKeys.favoriteCharacterIds,
          value: updatedFavoriteIds,
        );
      }

      return result;
    } catch (e) {
      return Left(LocalStorageFailure('Unknown Error: $e'));
    }
  }

  @override
  Future<Either<Failure, CharacterListingDto>> getFavoriteCharacters() async {
    try {
      final favoriteIdsResult = await getFavoriteCharacterIds();

      return await favoriteIdsResult.fold((failure) async => Left(failure), (
        favoriteIds,
      ) async {
        if (favoriteIds.isEmpty) {
          return Right(
            CharacterListingDto(characters: [], totalItems: 0, nextPage: null),
          );
        }

        final response = await httpManager.restRequest(
          url:
              'https://rickandmortyapi.com/api/character/[${favoriteIds.join(",")}]',
          method: HttpMethods.get,
        );

        if (response.statusCode != 200) {
          return Left(
            ServerFailure(
              response.statusMessage ?? 'Server Error',
              statusCode: response.statusCode,
            ),
          );
        }

        final characterListingDto = CharacterListingDto.fromJsonList(
          response.data,
        );

        return Right(characterListingDto);
      });
    } catch (e) {
      return Left(NetworkFailure('Unknown Error: $e'));
    }
  }
}
