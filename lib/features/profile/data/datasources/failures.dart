// profile/data/datasources/failures.dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}