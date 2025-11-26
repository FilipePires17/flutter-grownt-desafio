import 'package:flutter/material.dart';
import 'package:flutter_grownt_desafio/src/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_grownt_desafio/src/features/character/presentation/screens/character_screen.dart';
import 'package:flutter_grownt_desafio/src/features/character/domain/entities/character.dart';
import 'package:flutter_grownt_desafio/src/features/character/domain/enums/character_status_enum.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/presentation/cubit/character_listing_cubit.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/domain/entities/character_listing.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/domain/repositories/i_character_listing_repository.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/domain/usecases/get_characters.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/domain/usecases/get_favorite_character_ids.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/domain/usecases/get_favorite_characters.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/domain/usecases/toggle_character_favorite_status.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ICharacterListingRepository>()])
import 'character_screen_test.mocks.dart';

void _provideDummyValues() {
  provideDummy<Either<dynamic, dynamic>>(left(''));
  provideDummy<Either<dynamic, dynamic>>(right(''));
  provideDummy<Either<Error, bool>>(right(true));
  provideDummy<Either<Failure, List<int>>>(right([]));
}

void main() {
  late MockICharacterListingRepository repository;
  late CharacterListingCubit characterListingCubit;
  late Character sampleCharacter;

  setUpAll(() {
    _provideDummyValues();
  });

  setUp(() {
    repository = MockICharacterListingRepository();

    when(
      repository.toggleCharacterFavoriteStatus(any),
    ).thenAnswer((_) async => const Right([1]));

    when(
      repository.getFavoriteCharacterIds(),
    ).thenAnswer((_) async => const Right([]));

    characterListingCubit = CharacterListingCubit(
      getCharacters: GetCharacters(repository: repository),
      toggleCharacterFavoriteStatus: ToggleCharacterFavoriteStatus(
        repository: repository,
      ),
      getFavoriteCharacterIds: GetFavoriteCharacterIds(repository: repository),
      getFavoriteCharacters: GetFavoriteCharacters(repository: repository),
    );

    sampleCharacter = Character(
      id: 1,
      name: 'Rick Sanchez',
      status: CharacterStatusEnum.alive,
      species: 'Human',
      type: '',
      gender: 'Male',
      image: '',
      episode: const [],
      origin: 'Earth',
      location: 'Earth',
    );

    characterListingCubit.emit(
      characterListingCubit.state.copyWith(
        characterListing: CharacterListing(
          characters: [sampleCharacter],
          totalItems: 1,
        ),
      ),
    );
  });

  group('CharacterScreen Widget Tests', () {
    testWidgets('deve exibir informações do personagem corretamente', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CharacterListingCubit>.value(
            value: characterListingCubit,
            child: const CharacterScreen(index: 0),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Rick Sanchez'), findsOneWidget);
      expect(find.text('Status: '), findsOneWidget);
      expect(find.text('Species: '), findsOneWidget);
      expect(find.text('Gender: '), findsOneWidget);
      expect(find.text('Origin: '), findsOneWidget);
      expect(find.text('Location: '), findsOneWidget);
    });

    testWidgets('deve exibir ícone de favorito não preenchido inicialmente', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CharacterListingCubit>.value(
            value: characterListingCubit,
            child: const CharacterScreen(index: 0),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('deve favoritar ao tocar no ícone', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CharacterListingCubit>.value(
            value: characterListingCubit,
            child: const CharacterScreen(index: 0),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    blocTest<CharacterListingCubit, CharacterListingState>(
      'emite novo estado ao tocar favorito',
      build: () {
        final favoriteCharacter = sampleCharacter.copyWith(isFavorite: true);
        characterListingCubit.emit(
          characterListingCubit.state.copyWith(
            characterListing: CharacterListing(
              characters: [favoriteCharacter],
              totalItems: 1,
            ),
          ),
        );
        return characterListingCubit;
      },
      act: (cubit) async {
        cubit.toggleFavoriteStatus(sampleCharacter.id);
      },
      verify: (cubit) {
        expect(
          cubit.state.characterListing.characters.first.isFavorite,
          isFalse,
        );
      },
    );
  });
}
