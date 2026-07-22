import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Builds the single shared [Dio] instance. Every feature's Retrofit API
/// client is built from this instance, never a fresh `Dio()`.
Dio buildDioClient(AppConfig config, {required Future<String?> Function() getAuthToken}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.apiTimeout,
      receiveTimeout: config.apiTimeout,
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(getAuthToken: getAuthToken),
    if (config.isDebug) LoggingInterceptor(),
    ErrorInterceptor(),
  ]);

  return dio;
}
