import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/routes.dart';
import '../features/character/presentation/screens/character_screen.dart';
import '../features/character/presentation/cubit/character_cubit.dart';
import 'injection_container.dart';

class AppRouter {
  final _characterCubit = sl<CharacterCubit>();

  void dispose() {
    _characterCubit.close();
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.character:
      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _characterCubit,
            child: CharacterScreen(),
          ),
        );
    }
  }
}
