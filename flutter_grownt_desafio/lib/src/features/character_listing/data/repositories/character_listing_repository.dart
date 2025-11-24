import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/platforms/network_info.dart';
import '../../domain/entities/character_filters.dart';
import '../../domain/entities/character_listing.dart';
import '../../domain/repositories/i_character_listing_repository.dart';
import '../datasource/character_listing_datasource.dart';
import '../dtos/character_filters_dto.dart';

class CharacterListingRepository implements ICharacterListingRepository {
  final ICharacterListingDataSource dataSource;
  final INetworkInfo networkInfo;

  CharacterListingRepository({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CharacterListing>> getCharacters(
    CharacterFilters filters,
  ) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure('No internet connection'));
    }

    final result = await dataSource.getCharacters(
      CharacterFiltersDto.fromDomain(filters),
    );

    return result.fold((l) => Left(l), (dto) {
      return Right(dto);
    });
  }

  @override
  Future<Either<Failure, List<int>>> getFavoriteCharacterIds() async {
    final result = await dataSource.getFavoriteCharacterIds();
    return result;
  }

  @override
  Future<Either<Failure, List<int>>> toggleCharacterFavoriteStatus(
    int id,
  ) async {
    final result = await dataSource.toggleCharacterFavoriteStatus(id);
    return result;
  }

  @override
  Future<Either<Failure, CharacterListing>> getFavoriteCharacters() async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure('No internet connection'));
    }

    final result = await dataSource.getFavoriteCharacters();
    return result;
  }
}
