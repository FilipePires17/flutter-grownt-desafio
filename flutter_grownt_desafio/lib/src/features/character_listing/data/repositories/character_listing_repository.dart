import 'package:fpdart/fpdart.dart';

import '../../../../core/platforms/network_info.dart';
import '../../domain/entities/character_listing.dart';
import '../../domain/repositories/i_character_listing_repository.dart';
import '../datasource/character_listing_datasource.dart';

class CharacterListingRepository implements ICharacterListingRepository {
  final ICharacterListingDataSource dataSource;
  final INetworkInfo networkInfo;

  CharacterListingRepository({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<void, CharacterListing>> getCharacters({int page = 1}) async {
    if (await networkInfo.isConnected) {
      final result = await dataSource.getCharacters(page: page);

      return result.fold((l) => const Left(null), (dto) {
        return Right(dto);
      });
    } else {
      return const Left(null);
    }
  }
}
