## Versão do Flutter
Flutter 3.38.2 • Dart 3.10.0

## Como rodar o projeto
flutter pub get
flutter run

## Como rodar os testes
flutter test

## Decisões técnicas
A api escolhida foi a Rick and Morty API, portanto o aplicativo possui uma tela que exibe as personagens, tendo um filtro pelo nome da personagem e a opção de só mostrar os favoritos, ao clicar em uma das personagens o usuário é levado a tela de detalhes dessa personagem.
O código foi organizado usando a estrutura de feature-first, a arquitetura utilizada é uma pequena adaptação da clean archtecture para o Flutter, dentro de cada feature há no máximo 3 camadas: domínio, fonte de dados e apresentação. O domínio define toda a lógica de negócio, a fonte de dados lida com as fontes remotas e locais de dados convertendo os dados para algo que se encaixe no meu domínio, a camada de apresentação lida com o gerenciamento de estados e toda a parte visual.

### Ferramentas utilizadas
Para gerenciamento de estado foi utilizado o bloc juntamente com o getit. Para persistência de dados localmente foi utilizado o Hive.

### Testes
Para os testes as ferramentas utilizadas foram: mockito para criar classes com métodos mockados e bloc_test para testar os estados dos blocs da aplicação.