/// Base failure type surfaced to `presentation/` — never expose raw
/// exceptions or [DioException] directly to widgets.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error, please try again.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on our end.']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Invalid credentials.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}
