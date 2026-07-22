import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Typed wrapper over [FlutterSecureStorage] for sensitive data only:
/// auth tokens, refresh tokens, credentials — anything that must survive
/// only on-device and encrypted.
///
/// No raw string-key access outside this file. `auth_interceptor.dart`
/// reads the auth token through this store, never `preferences_store.dart`.
class SecureStore {
  SecureStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _authTokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<String?> getAuthToken() => _storage.read(key: _authTokenKey);

  Future<void> setAuthToken(String token) =>
      _storage.write(key: _authTokenKey, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> setRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<void> clear() => _storage.deleteAll();
}
