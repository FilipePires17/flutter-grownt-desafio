import 'package:hive_flutter/adapters.dart';
import '../../../core/constants/local_storage_keys.dart';

class HiveInitialize {
  Future init() async {
    await Hive.initFlutter();
    await _initializeDefaultBoxes();
  }

  Future<void> _initializeDefaultBoxes() async {
    final appBox = await Hive.openBox(LocalStorageBoxes.appBox);

    if (!appBox.containsKey(LocalStorageKeys.favoriteCharacterIds)) {
      await appBox.put(LocalStorageKeys.favoriteCharacterIds, <int>[]);
    }
  }
}
