import 'package:dio/dio.dart';

import '../../utils/logger.dart';

/// Request/response logging — only attached when `AppConfig.isDebug` is
/// true (see `dio_client.dart`). Never log bodies in release builds.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('--> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug('<-- ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('<-- ERROR ${err.requestOptions.uri}', err);
    handler.next(err);
  }
}
