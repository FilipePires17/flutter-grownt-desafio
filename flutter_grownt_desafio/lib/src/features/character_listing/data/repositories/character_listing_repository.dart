import 'package:fpdart/fpdart.dart';

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
  Future<Either<void, CharacterListing>> getCharacters(
    CharacterFilters filters,
  ) async {
    if (await networkInfo.isConnected) {
      final result = await dataSource.getCharacters(
        CharacterFiltersDto.fromDomain(filters),
      );

      return result.fold((l) => const Left(null), (dto) {
        return Right(dto);
      });
    } else {
      return const Left(null);
    }
  }

  @override
  Future<Either<void, List<int>>> getFavoriteCharacterIds() async {
    final result = await dataSource.getFavoriteCharacterIds();
    return result;
  }

  @override
  Future<Either<void, List<int>>> toggleCharacterFavoriteStatus(int id) async {
    final result = await dataSource.toggleCharacterFavoriteStatus(id);
    return result;
  }
}
