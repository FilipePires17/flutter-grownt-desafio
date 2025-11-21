import 'package:hive_flutter/adapters.dart';

class HiveInitialize {
  Future init() async {
    await Hive.initFlutter();
  }
}
