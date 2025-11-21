import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/character_listing.dart';
import '../../domain/usecases/get_characters.dart';

part 'character_listing_state.dart';

class CharacterListingCubit extends Cubit<CharacterListingState> {
  CharacterListingCubit({required this.getCharacters})
    : super(CharacterListingState());

  final GetCharacters getCharacters;

  void fetchCharacters() async {
    emit(state.copyWith(status: CharacterListingStatus.loading));

    final result = await getCharacters(
      page: state.characterListing?.nextPage ?? 1,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CharacterListingStatus.error,
            errorMessage: 'Failed to fetch characters',
          ),
        );
      },
      (characterListing) {
        emit(
          state.copyWith(
            status: CharacterListingStatus.loaded,
            characterListing: characterListing,
          ),
        );
      },
    );
  }
}
