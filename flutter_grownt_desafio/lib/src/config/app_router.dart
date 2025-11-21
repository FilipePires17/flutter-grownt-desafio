import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/routes.dart';
import '../features/character/presentation/screens/character_screen.dart';
import '../features/character/presentation/cubit/character_cubit.dart';
import '../features/character_listing/presentation/cubit/character_listing_cubit.dart';
import '../features/character_listing/presentation/screens/characterlisting_screen.dart';
import 'injection_container.dart';

class AppRouter {
  final _characterCubit = sl<CharacterCubit>();
  final _characterListingCubit = sl<CharacterListingCubit>();

  void dispose() {
    _characterCubit.close();
    _characterListingCubit.close();
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.character:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _characterCubit,
            child: CharacterScreen(),
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
