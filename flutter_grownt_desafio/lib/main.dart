import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app.dart';
import 'src/core/data/local/hive_initializer.dart';
import 'src/config/injection_container.dart' as getit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInitialize().init();
  getit.initContainer();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}
