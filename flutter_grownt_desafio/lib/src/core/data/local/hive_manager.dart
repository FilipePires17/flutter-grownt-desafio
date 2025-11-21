import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import 'local_storage_manager.dart';

class HiveLocalStorageCaller implements ILocalStorageCaller {
  @override
  Future<Either<Error, bool>> saveData({
    required String table,
    required String key,
    required value,
  }) async {
    try {
      await Hive.openBox(table);
      Box box = Hive.box(table);
      box.put(key, value);
      return Right(box.get(key) != null);
    } catch (e) {
      return Left(e as Error);
    }
  }

  @override
  Future<Either<dynamic, dynamic>> restoreData({
    required String? table,
    required String key,
  }) async {
    if (table == null) {
      return const Right(null);
    }
    await Hive.openBox(table);
    try {
      Box box = Hive.box(table);
      final keyRes = box.get(key);
      if (keyRes != null) {
        return Right(keyRes);
      } else {
        return const Left(null);
      }
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Error, bool>> clearAll({required String table}) async {
    final box = await Hive.openBox(table);
    if ((await box.clear()) > 0) {
      return const Right(true);
    } else {
      return Left(Error());
    }
  }

  @override
  Future<Either<Error, Map>> getAllEntries(String table) async {
    final box = await Hive.openBox(table);
    return Right(Map.fromIterables(box.keys, box.values));
  }

  @override
  Future<Either<Error, List<String>>> getAllKeys(String table) async {
    final box = await Hive.openBox(table);
    return Right(box.keys.map((e) => e.toString()).toList());
  }

  @override
  Future<Either<Error, List>> getAllValues(String table) async {
    final box = await Hive.openBox(table);
    return Right(box.values.toList());
  }

  @override
  Future<Either<String, bool>> deleteKey({
    required String table,
    required String key,
  }) async {
    final box = await Hive.openBox(table);
    try {
      await box.delete(key);
    } catch (e) {
      return const Left('Erro ao acessar o banco de dados');
    }

    return Right(box.get(key) == null);
  }
}
