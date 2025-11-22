import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/character_filters.dart';
import '../../domain/entities/character_listing.dart';
import '../../domain/usecases/get_characters.dart';
import '../../domain/usecases/get_favorite_character_ids.dart';
import '../../domain/usecases/toggle_character_favorite_status.dart';

part 'character_listing_state.dart';

class CharacterListingCubit extends Cubit<CharacterListingState> {
  CharacterListingCubit({
    required this.getCharacters,
    required this.toggleCharacterFavoriteStatus,
    required this.getFavoriteCharacterIds,
  }) : super(CharacterListingState());

  final GetCharacters getCharacters;
  final ToggleCharacterFavoriteStatus toggleCharacterFavoriteStatus;
  final GetFavoriteCharacterIds getFavoriteCharacterIds;

  void fetchCharacters(CharacterFilters filters) async {
    if (state.characterListing.characters.isEmpty) {
      emit(state.copyWith(status: CharacterListingStatus.loading));
      await loadFavoriteCharacterIds();
    }

    if (filters.page <= 1) {
      emit(
        state.copyWith(
          characterListing: CharacterListing(characters: []),
          status: CharacterListingStatus.loading,
        ),
      );
    }

    final result = await getCharacters(filters);

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
        final updatedCharacters = characterListing.characters.map((character) {
          return character.copyWith(
            isFavorite: state.characterListing.favoriteCharacterIds.contains(
              character.id,
            ),
          );
        }).toList();
        emit(
          state.copyWith(
            status: CharacterListingStatus.loaded,
            characterListing: state.characterListing.copyWith(
              characters: [
                ...state.characterListing.characters,
                ...updatedCharacters,
              ],
              totalItems: characterListing.totalItems,
              nextPage: characterListing.nextPage,
            ),
          ),
        );
      },
    );
  }

  void toggleFavoriteStatus(int characterId) async {
    final result = await toggleCharacterFavoriteStatus(characterId);

    result.fold(
      (failure) {
        // Handle failure if needed
      },
      (updatedFavoriteIds) {
        final updatedCharacters = state.characterListing.characters.map((
          character,
        ) {
          if (character.id == characterId) {
            return character.copyWith(isFavorite: !character.isFavorite);
          }
          return character;
        }).toList();

        emit(
          state.copyWith(
            characterListing: state.characterListing.copyWith(
              characters: updatedCharacters,
              favoriteCharacterIds: updatedFavoriteIds,
            ),
          ),
        );
      },
    );
  }

  Future<void> loadFavoriteCharacterIds() async {
    final result = await getFavoriteCharacterIds();

    result.fold(
      (failure) {
        // Handle failure if needed
      },
      (favoriteIds) {
        emit(
          state.copyWith(
            characterListing: state.characterListing.copyWith(
              favoriteCharacterIds: favoriteIds,
            ),
          ),
        );
      },
    );
  }
}
