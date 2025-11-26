import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grownt_desafio/src/core/data/local/local_storage_manager.dart';
import 'package:flutter_grownt_desafio/src/core/data/remote/http_manager.dart';
import 'package:flutter_grownt_desafio/src/core/error/failure.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/data/datasource/character_listing_datasource.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/data/dtos/character_filters_dto.dart';
import 'package:flutter_grownt_desafio/src/features/character_listing/data/dtos/character_listing_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';

@GenerateNiceMocks([MockSpec<HttpManager>(), MockSpec<ILocalStorageCaller>()])
import 'character_listing_datasource_test.mocks.dart';

void _provideDummyValues() {
  provideDummy<Either<dynamic, dynamic>>(left(''));
  provideDummy<Either<dynamic, dynamic>>(right(''));
  provideDummy<Either<Error, bool>>(right(true));
}

void main() {
  late CharacterListingDatasource dataSource;
  late MockHttpManager mockHttpManager;
  late MockILocalStorageCaller mockLocalStorageCaller;

  setUpAll(() {
    _provideDummyValues();
  });

  setUp(() {
    mockHttpManager = MockHttpManager();
    mockLocalStorageCaller = MockILocalStorageCaller();
    dataSource = CharacterListingDatasource(
      httpManager: mockHttpManager,
      localStorageCaller: mockLocalStorageCaller,
    );
  });

  final tFilters = CharacterFiltersDto(page: 1, name: 'Rick');

  final tJsonMap = {
    'info': {
      'count': 1,
      'pages': 1,
      'next': 'https://rickandmortyapi.com/api/character/?page=2',
      'prev': null,
    },
    'results': [
      {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'gender': 'Male',
        'type': '',
        'origin': {'name': 'Earth'},
        'location': {'name': 'Earth'},
        'image': 'url',
        'episode': [],
      },
    ],
  };

  final tWrongJsonMap = {
    'info': {
      'count': 1,
      'pages': 1,
      'next': 'https://rickandmortyapi.com/api/character/?page=2',
      'prev': null,
    },
    'results': [
      {
        'id': 1,
        'nome': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'gender': 'Male',
        'type': '',
        'origin': {'name': 'Earth'},
        'location': {'name': 'Earth'},
        'image': 'url',
        'episode': [],
      },
    ],
  };

  final tFavoritesJsonMap = [
    {
      'id': 1,
      'name': 'Rick Sanchez',
      'status': 'Alive',
      'species': 'Human',
      'gender': 'Male',
      'type': '',
      'origin': {'name': 'Earth'},
      'location': {'name': 'Earth'},
      'image': 'url',
      'episode': [],
    },
  ];

  final tHttpResponseSuccess = Response(
    data: tJsonMap,
    statusCode: 200,
    requestOptions: RequestOptions(),
  );
  final tHttpResponseSuccessWrongData = Response(
    data: tWrongJsonMap,
    statusCode: 200,
    requestOptions: RequestOptions(),
  );
  final tHttpResponseSuccessFavorite = Response(
    data: tFavoritesJsonMap,
    statusCode: 200,
    requestOptions: RequestOptions(),
  );
  final tHttpResponseError = Response(
    data: {},
    statusCode: 404,
    requestOptions: RequestOptions(),
  );

  group('getCharacters', () {
    test(
      'deve retornar CharacterListingDto quando o status code for 200',
      () async {
        when(
          mockHttpManager.restRequest(
            url: anyNamed('url'),
            method: anyNamed('method'),
            parameters: anyNamed('parameters'),
          ),
        ).thenAnswer((_) async => tHttpResponseSuccess);

        final result = await dataSource.getCharacters(tFilters);

        expect(result.isRight(), true);
        result.fold(
          (l) => fail('Deveria ser Right'),
          (r) => expect(r, isA<CharacterListingDto>()),
        );

        verify(
          mockHttpManager.restRequest(
            url: 'https://rickandmortyapi.com/api/character',
            method: HttpMethods.get,
            parameters: tFilters.toQueryParameters(),
          ),
        ).called(1);
      },
    );

    test(
      'deve retornar Left(Failure) quando o status code for diferente de 200',
      () async {
        when(
          mockHttpManager.restRequest(
            url: anyNamed('url'),
            method: anyNamed('method'),
            parameters: anyNamed('parameters'),
          ),
        ).thenAnswer((_) async => tHttpResponseError);

        final result = await dataSource.getCharacters(tFilters);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, isA<ServerFailure>()),
          (list) => fail('Falha'),
        );
      },
    );

    test(
      'deve retornar Left(Failure) quando o json estiver incorreto',
      () async {
        when(
          mockHttpManager.restRequest(
            url: anyNamed('url'),
            method: anyNamed('method'),
            parameters: anyNamed('parameters'),
          ),
        ).thenAnswer((_) async => tHttpResponseSuccessWrongData);

        final result = await dataSource.getCharacters(tFilters);

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, isA<DataParsingFailure>()),
          (list) => fail('Falha'),
        );
      },
    );

    test('deve retornar Left(Failure) quando ocorrer uma exceção', () async {
      when(
        mockHttpManager.restRequest(
          url: anyNamed('url'),
          method: anyNamed('method'),
          parameters: anyNamed('parameters'),
        ),
      ).thenThrow(Exception('Erro de conexão'));

      final result = await dataSource.getCharacters(tFilters);

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<NetworkFailure>()),
        (list) => fail('Falha'),
      );
    });
  });

  group('getFavoriteCharacterIds', () {
    test('deve retornar Left(Failure) quando ocorrer uma exceção', () async {
      when(
        mockLocalStorageCaller.restoreData(
          table: anyNamed('table'),
          key: anyNamed('key'),
        ),
      ).thenAnswer((_) async => const Left(null));

      final result = await dataSource.getFavoriteCharacterIds();

      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, isA<LocalStorageFailure>()),
        (list) => fail('Falha'),
      );
    });
  });

  group('toggleCharacterFavoriteStatus', () {
    const tId = 1;

    test('deve ADICIONAR aos favoritos se não estiver na lista', () async {
      when(
        mockLocalStorageCaller.restoreData(
          table: anyNamed('table'),
          key: anyNamed('key'),
        ),
      ).thenAnswer((_) async => const Right(<int>[]));

      when(
        mockLocalStorageCaller.saveData(
          table: anyNamed('table'),
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async => Right(true));

      final result = await dataSource.toggleCharacterFavoriteStatus(tId);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Falha'),
        (list) => expect(list.contains(tId), true),
      );

      verify(
        mockLocalStorageCaller.saveData(
          table: anyNamed('table'),
          key: anyNamed('key'),
          value: [tId],
        ),
      ).called(1);
    });

    test('deve REMOVER dos favoritos se já estiver na lista', () async {
      when(
        mockLocalStorageCaller.restoreData(
          table: anyNamed('table'),
          key: anyNamed('key'),
        ),
      ).thenAnswer((_) async => const Right([tId]));

      when(
        mockLocalStorageCaller.saveData(
          table: anyNamed('table'),
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async => Right(true));

      final result = await dataSource.toggleCharacterFavoriteStatus(tId);

      expect(result.isRight(), true);
      result.fold((l) => fail('Falha'), (list) => expect(list.isEmpty, true));
    });

    test(
      'deve retornar Left(Failure) caso não seja possível salvar a atualização de status',
      () async {
        when(
          mockLocalStorageCaller.restoreData(
            table: anyNamed('table'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => const Right([tId]));

        when(
          mockLocalStorageCaller.saveData(
            table: anyNamed('table'),
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async => Left(Error()));

        final result = await dataSource.toggleCharacterFavoriteStatus(tId);

        debugPrint(result.toString());

        expect(result.isLeft(), true);
        result.fold(
          (l) => expect(l, isA<LocalStorageFailure>()),
          (list) => fail('falha'),
        );
      },
    );
  });

  group('getFavoriteCharacters', () {
    test(
      'deve retornar lista vazia sem chamar API se não houver favoritos',
      () async {
        when(
          mockLocalStorageCaller.restoreData(
            table: anyNamed('table'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => const Right(<int>[]));

        final result = await dataSource.getFavoriteCharacters();

        expect(result.isRight(), true);
        result.fold((l) => null, (r) => expect(r.characters.isEmpty, true));

        verifyNever(
          mockHttpManager.restRequest(
            url: anyNamed('url'),
            method: anyNamed('method'),
          ),
        );
      },
    );

    test('deve retornar Right(List) quando a API retorna status 200', () async {
      when(
        mockLocalStorageCaller.restoreData(
          table: anyNamed('table'),
          key: anyNamed('key'),
        ),
      ).thenAnswer((_) async => Right([1]));

      when(
        mockHttpManager.restRequest(
          url: anyNamed('url'),
          method: anyNamed('method'),
          parameters: anyNamed('parameters'),
        ),
      ).thenAnswer((_) async => tHttpResponseSuccessFavorite);

      final result = await dataSource.getFavoriteCharacters();

      expect(result.isRight(), true);

      verify(
        mockHttpManager.restRequest(
          url: anyNamed('url'),
          method: anyNamed('method'),
        ),
      ).called(1);
    });

    test(
      'deve retornar Left(Failure) quando a API retorna status diferente de 200',
      () async {
        when(
          mockLocalStorageCaller.restoreData(
            table: anyNamed('table'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => Right([1]));

        when(
          mockHttpManager.restRequest(
            url: anyNamed('url'),
            method: anyNamed('method'),
            parameters: anyNamed('parameters'),
          ),
        ).thenAnswer((_) async => tHttpResponseError);

        final result = await dataSource.getFavoriteCharacters();

        expect(result.isLeft(), true);

        verify(
          mockHttpManager.restRequest(
            url: anyNamed('url'),
            method: anyNamed('method'),
          ),
        ).called(1);
      },
    );

    test(
      'deve retornar Left(Failure) quando a API retorna dados incorretos',
      () async {
        when(
          mockLocalStorageCaller.restoreData(
            table: anyNamed('table'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => Right([1]));

        when(
          mockHttpManager.restRequest(
            url: anyNamed('url'),
            method: anyNamed('method'),
            parameters: anyNamed('parameters'),
          ),
        ).thenAnswer((_) async => tHttpResponseSuccessWrongData);

        final result = await dataSource.getFavoriteCharacters();

        expect(result.isLeft(), true);

        verify(
          mockHttpManager.restRequest(
            url: anyNamed('url'),
            method: anyNamed('method'),
          ),
        ).called(1);
      },
    );

    test('deve retornar Left(Failure) quando uma exceção é lançada', () async {
      when(
        mockLocalStorageCaller.restoreData(
          table: anyNamed('table'),
          key: anyNamed('key'),
        ),
      ).thenAnswer((_) async => Right([1]));

      when(
        mockHttpManager.restRequest(
          url: anyNamed('url'),
          method: anyNamed('method'),
          parameters: anyNamed('parameters'),
        ),
      ).thenThrow(Exception('Network Error'));

      final result = await dataSource.getFavoriteCharacters();

      expect(result.isLeft(), true);

      verify(
        mockHttpManager.restRequest(
          url: anyNamed('url'),
          method: anyNamed('method'),
        ),
      ).called(1);
    });
  });
}
