import '../failures/failures.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success({required this.data});
}

class ResultError<T> extends Result<T> {
  final Failure failure;
  const ResultError({required this.failure});
}
