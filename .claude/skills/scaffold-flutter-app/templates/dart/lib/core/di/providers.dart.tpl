import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../storage/preferences_store.dart';
import '../storage/secure_store.dart';

/// App-wide singletons — overridden in `main.dart` with real instances
/// before `runApp`, and overridden again in tests via
/// `ProviderScope(overrides: [...])`.

/// Set in `main.dart`: `ProviderScope(overrides: [appConfigProvider.overrideWithValue(config)])`.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden in main.dart');
});

/// Set in `main.dart` after `SharedPreferences.getInstance()`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final preferencesStoreProvider = Provider<PreferencesStore>((ref) {
  return PreferencesStore(ref.watch(sharedPreferencesProvider));
});

final secureStoreProvider = Provider<SecureStore>((ref) {
  return SecureStore(ref.watch(secureStorageProvider));
});

final dioClientProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final secureStore = ref.watch(secureStoreProvider);
  return buildDioClient(config, getAuthToken: secureStore.getAuthToken);
});
