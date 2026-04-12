abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
