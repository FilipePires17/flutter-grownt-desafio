import 'data_connection_checker.dart';

abstract class INetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfo implements INetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  NetworkInfo({required this.dataConnectionChecker});

  @override
  Future<bool> get isConnected async =>
      await dataConnectionChecker.hasConnection;
}
