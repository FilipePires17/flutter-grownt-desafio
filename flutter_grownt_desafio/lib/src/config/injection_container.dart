import 'package:get_it/get_it.dart';

import '../core/data/local/hive_manager.dart';
import '../core/data/local/local_storage_manager.dart';
import '../core/data/remote/http_manager.dart';
import '../core/platforms/data_connection_checker.dart';
import '../core/platforms/network_info.dart';
import '../features/character/data/datasources/character_datasource.dart';
import '../features/character/data/repositories/character_repository.dart';
import '../features/character/domain/repositories/i_character_repository.dart';
import '../features/character/domain/usecases/get_character_by_id.dart';
import '../features/character/domain/usecases/toggle_character_favorite_status.dart';
import '../features/character/presentation/cubit/character_cubit.dart';
import '../features/character_listing/data/datasource/character_listing_datasource.dart';
import '../features/character_listing/data/repositories/character_listing_repository.dart';
import '../features/character_listing/domain/repositories/i_character_listing_repository.dart';
import '../features/character_listing/domain/usecases/get_characters.dart';
import '../features/character_listing/presentation/cubit/character_listing_cubit.dart';

final sl = GetIt.instance;

void initContainer() {
  // Character
  sl.registerFactory(
    () => CharacterCubit(
      getCharacterById: sl(),
      toggleCharacterFavoriteStatus: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCharacterById(repository: sl()));
  sl.registerLazySingleton(
    () => ToggleCharacterFavoriteStatus(repository: sl()),
  );
  sl.registerLazySingleton<ICharacterRepository>(
    () => CharacterRepository(dataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<ICharacterDataSource>(
    () => CharacterDataSource(httpManager: sl(), localStorageCaller: sl()),
  );

  // Listing
  sl.registerFactory(() => CharacterListingCubit(getCharacters: sl()));

  sl.registerLazySingleton(() => GetCharacters(repository: sl()));
  sl.registerLazySingleton<ICharacterListingRepository>(
    () => CharacterListingRepository(dataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<ICharacterListingDataSource>(
    () => CharacterListingDatasource(httpManager: sl()),
  );

  // Core
  sl.registerLazySingleton<INetworkInfo>(
    () => NetworkInfo(dataConnectionChecker: sl()),
  );
  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton(() => HttpManager());
  sl.registerLazySingleton<ILocalStorageCaller>(() => HiveLocalStorageCaller());
}
