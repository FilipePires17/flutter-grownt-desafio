import 'package:get_it/get_it.dart';

import '../core/data/local/hive_manager.dart';
import '../core/data/local/local_storage_manager.dart';
import '../core/data/remote/http_manager.dart';
import '../core/platforms/data_connection_checker.dart';
import '../core/platforms/network_info.dart';
import '../features/character_listing/domain/usecases/toggle_character_favorite_status.dart';
import '../features/character_listing/data/datasource/character_listing_datasource.dart';
import '../features/character_listing/data/repositories/character_listing_repository.dart';
import '../features/character_listing/domain/repositories/i_character_listing_repository.dart';
import '../features/character_listing/domain/usecases/get_characters.dart';
import '../features/character_listing/domain/usecases/get_favorite_character_ids.dart';
import '../features/character_listing/presentation/cubit/character_listing_cubit.dart';

final sl = GetIt.instance;

void initContainer() {
  // Listing
  sl.registerFactory(
    () => CharacterListingCubit(
      getCharacters: sl(),
      toggleCharacterFavoriteStatus: sl(),
      getFavoriteCharacterIds: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCharacters(repository: sl()));
  sl.registerLazySingleton(() => GetFavoriteCharacterIds(repository: sl()));
  sl.registerLazySingleton(
    () => ToggleCharacterFavoriteStatus(repository: sl()),
  );
  sl.registerLazySingleton<ICharacterListingRepository>(
    () => CharacterListingRepository(dataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<ICharacterListingDataSource>(
    () =>
        CharacterListingDatasource(httpManager: sl(), localStorageCaller: sl()),
  );

  // Core
  sl.registerLazySingleton<INetworkInfo>(
    () => NetworkInfo(dataConnectionChecker: sl()),
  );
  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton(() => HttpManager());
  sl.registerLazySingleton<ILocalStorageCaller>(() => HiveLocalStorageCaller());
}
