import 'package:dio/dio.dart';

import '../../errors/exceptions.dart';

/// Maps transport-level [DioException]s into the app's exception types
/// (see `core/errors/exceptions.dart`), so `data/repositories/` only
/// throws/handles app exceptions, never raw [DioException].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        handler.next(err.copyWith(error: const NetworkException()));
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        if (status == 401 || status == 403) {
          handler.next(err.copyWith(error: const UnauthorizedException()));
        } else {
          handler.next(err.copyWith(error: const ServerException()));
        }
      default:
        handler.next(err);
    }
  }
}
