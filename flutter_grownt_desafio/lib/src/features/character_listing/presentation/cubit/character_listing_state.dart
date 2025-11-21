part of 'character_listing_cubit.dart';

enum CharacterListingStatus { initial, loading, loaded, error }

class CharacterListingState extends Equatable {
  final CharacterListingStatus status;
  final CharacterListing characterListing;
  final String? errorMessage;

  const CharacterListingState({
    this.status = CharacterListingStatus.initial,
    this.characterListing = const CharacterListing(),
    this.errorMessage,
  });

  CharacterListingState copyWith({
    CharacterListingStatus? status,
    CharacterListing? characterListing,
    String? errorMessage,
  }) {
    return CharacterListingState(
      status: status ?? this.status,
      characterListing: characterListing ?? this.characterListing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, characterListing, errorMessage];
}
