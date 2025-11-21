import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/routes.dart';
import '../features/character/presentation/screens/character_screen.dart';
import '../features/character_listing/presentation/cubit/character_listing_cubit.dart';
import '../features/character_listing/presentation/screens/character_listing_screen.dart';
import 'injection_container.dart';

class AppRouter {
  final _characterListingCubit = sl<CharacterListingCubit>();

  void dispose() {
    _characterListingCubit.close();
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.character:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _characterListingCubit,
            child: CharacterScreen(index: settings.arguments as int),
          ),
        );

      case RouteNames.characterListing:
      default:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _characterListingCubit,
            child: CharacterListingScreen(),
          ),
        );
    }
  }
}
