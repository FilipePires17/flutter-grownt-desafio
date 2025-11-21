import 'package:fpdart/fpdart.dart';

import '../../../../core/data/remote/http_manager.dart';
import '../dtos/character_listing_dto.dart';

abstract class ICharacterListingDataSource {
  Future<Either<void, CharacterListingDto>> getCharacters({int page = 1});
}

class CharacterListingDatasource implements ICharacterListingDataSource {
  final HttpManager httpManager;

  const CharacterListingDatasource({required this.httpManager});

  @override
  Future<Either<void, CharacterListingDto>> getCharacters({
    int page = 1,
  }) async {
    try {
      final response = await httpManager.restRequest(
        url: 'https://rickandmortyapi.com/api/character',
        method: HttpMethods.get,
        parameters: {'page': page},
      );

      final characterListingDto = CharacterListingDto.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(characterListingDto);
    } catch (e) {
      return const Left(null);
    }
  }
}
