import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/character.dart';
import '../../domain/usecases/get_character_by_id.dart';
import '../../domain/usecases/toggle_character_favorite_status.dart';

part 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterCubit({
    required this.getCharacterById,
    required this.toggleCharacterFavoriteStatus,
  }) : super(const CharacterState());

  final GetCharacterById getCharacterById;
  final ToggleCharacterFavoriteStatus toggleCharacterFavoriteStatus;

  Future<void> fetchCharacter(int id) async {
    emit(state.copyWith(status: CharacterStateStatus.loading));

    final result = await getCharacterById(id);

    result.fold(
      (failure) {
        emit(state.copyWith(status: CharacterStateStatus.error));
      },
      (character) {
        emit(
          state.copyWith(
            status: CharacterStateStatus.loaded,
            character: character,
          ),
        );
      },
    );
  }

  Future<void> toggleFavoriteStatus() async {
    if (state.character == null) return;

    emit(
      state.copyWith(
        character: state.character!.copyWith(
          isFavorite: !state.character!.isFavorite,
        ),
      ),
    );

    final result = await toggleCharacterFavoriteStatus(state.character!.id);

    result.fold(
      (failure) {
        emit(state.copyWith(status: CharacterStateStatus.error));
      },
      (isFavorite) {
        emit(
          state.copyWith(
            character: state.character!.copyWith(isFavorite: isFavorite),
          ),
        );
      },
    );
  }
}
