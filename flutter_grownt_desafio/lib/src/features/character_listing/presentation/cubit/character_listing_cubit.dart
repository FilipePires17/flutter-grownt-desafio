import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/character_filters.dart';
import '../../domain/entities/character_listing.dart';
import '../../domain/usecases/get_characters.dart';
import '../../domain/usecases/get_favorite_character_ids.dart';
import '../../domain/usecases/get_favorite_characters.dart';
import '../../domain/usecases/toggle_character_favorite_status.dart';

part 'character_listing_state.dart';

class CharacterListingCubit extends Cubit<CharacterListingState> {
  CharacterListingCubit({
    required this.getCharacters,
    required this.toggleCharacterFavoriteStatus,
    required this.getFavoriteCharacterIds,
    required this.getFavoriteCharacters,
  }) : super(CharacterListingState());

  final GetCharacters getCharacters;
  final ToggleCharacterFavoriteStatus toggleCharacterFavoriteStatus;
  final GetFavoriteCharacterIds getFavoriteCharacterIds;
  final GetFavoriteCharacters getFavoriteCharacters;

  void fetchCharacters(CharacterFilters filters) async {
    if (state.characterListing.characters.isEmpty) {
      emit(state.copyWith(status: CharacterListingStatus.loading));
      await loadFavoriteCharacterIds();
    }

    if (state.status == CharacterListingStatus.error) {
      emit(state.copyWith(status: CharacterListingStatus.loaded));
    }

    if (filters.page <= 1) {
      emit(
        state.copyWith(
          characterListing: state.characterListing.copyWith(
            characters: [],
            totalItems: 0,
            nextPage: null,
          ),
          status: CharacterListingStatus.loading,
        ),
      );
    }

    final result = await getCharacters(filters);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: state.characterListing.characters.isEmpty
                ? CharacterListingStatus.initialError
                : CharacterListingStatus.error,
            error: failure,
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
        emit(
          state.copyWith(status: CharacterListingStatus.error, error: failure),
        );
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
        emit(
          state.copyWith(status: CharacterListingStatus.error, error: failure),
        );
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

  void fetchFavoriteCharacters() {
    emit(state.copyWith(status: CharacterListingStatus.loading));

    getFavoriteCharacters().then((result) {
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: CharacterListingStatus.initialError,
              error: failure,
            ),
          );
        },
        (characterListing) {
          final updatedCharacters = characterListing.characters.map((
            character,
          ) {
            return character.copyWith(isFavorite: true);
          }).toList();
          emit(
            state.copyWith(
              status: CharacterListingStatus.loaded,
              characterListing: state.characterListing.copyWith(
                characters: updatedCharacters,
                totalItems: characterListing.characters.length,
                nextPage: characterListing.nextPage,
              ),
            ),
          );
        },
      );
    });
  }
}
