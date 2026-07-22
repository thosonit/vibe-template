import 'package:dio/dio.dart';

/// Attaches the auth token from [secureStoreProvider] to every outgoing
/// request. Single concern — does not log or handle errors.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.getAuthToken});

  final Future<String?> Function() getAuthToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
