/// Exceptions thrown by `data/` layer (datasources). Mapped to [Failure]
/// by `error_interceptor.dart` or the repository implementation.
class NetworkException implements Exception {
  const NetworkException([this.message = 'Network error']);

  final String message;
}

class ServerException implements Exception {
  const ServerException([this.message = 'Server error']);

  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized']);

  final String message;
}

class StorageException implements Exception {
  const StorageException([this.message = 'Storage error']);

  final String message;
}
