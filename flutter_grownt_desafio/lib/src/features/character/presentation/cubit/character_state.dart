part of 'character_cubit.dart';

enum CharacterStateStatus { initial, loading, loaded, error }

class CharacterState extends Equatable {
  final Character? character;
  final CharacterStateStatus status;
  final String? errorMessage;

  const CharacterState({
    this.character,
    this.status = CharacterStateStatus.initial,
    this.errorMessage,
  });

  CharacterState copyWith({
    Character? character,
    CharacterStateStatus? status,
    String? errorMessage,
  }) {
    return CharacterState(
      character: character ?? this.character,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [character, status, errorMessage];
}
