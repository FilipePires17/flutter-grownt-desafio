part of 'character_listing_cubit.dart';

enum CharacterListingStatus { initial, loading, loaded, error, initialError }

class CharacterListingState extends Equatable {
  final CharacterListingStatus status;
  final CharacterListing characterListing;
  final Failure? error;

  const CharacterListingState({
    this.status = CharacterListingStatus.initial,
    this.characterListing = const CharacterListing(),
    this.error,
  });

  CharacterListingState copyWith({
    CharacterListingStatus? status,
    CharacterListing? characterListing,
    Failure? error,
  }) {
    return CharacterListingState(
      status: status ?? this.status,
      characterListing: characterListing ?? this.characterListing,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, characterListing, error];
}
