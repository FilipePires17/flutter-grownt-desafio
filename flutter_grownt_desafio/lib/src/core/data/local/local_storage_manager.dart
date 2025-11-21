import 'package:fpdart/fpdart.dart';

abstract class ILocalStorageCaller {
  Future<Either<Error, bool>> saveData({
    required String table,
    required String key,
    required dynamic value,
  });

  Future<Either<dynamic, dynamic>> restoreData({
    required String table,
    required String key,
  });

  Future<Either<String, bool>> deleteKey({
    required String table,
    required String key,
  });

  Future<Either<Error, List<String>>> getAllKeys(String table);

  Future<Either<Error, List>> getAllValues(String table);

  Future<Either<Error, Map>> getAllEntries(String table);

  Future<Either<Error, bool>> clearAll({required String table});
}
