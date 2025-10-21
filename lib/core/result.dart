abstract class Result<T> {
  const Result();
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) => this is Success<T>
      ? success((this as Success<T>).data)
      : failure((this as FailureResult).failure);
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}

class Failure {
  final String message;
  final int? statusCode;
  const Failure(this.message, {this.statusCode});
  @override
  String toString() => 'Failure($statusCode, $message)';
}
