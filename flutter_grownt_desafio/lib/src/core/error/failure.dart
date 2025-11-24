abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class LocalStorageFailure extends Failure {
  const LocalStorageFailure(super.message);
}

class DataParsingFailure extends Failure {
  const DataParsingFailure(super.message);
}
