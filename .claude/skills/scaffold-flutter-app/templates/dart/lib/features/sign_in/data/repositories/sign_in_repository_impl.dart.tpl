import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/secure_store.dart';
import '../../domain/repositories/sign_in_repository.dart';
import '../datasources/sign_in_remote_datasource.dart';
import '../models/sign_in_session_model.dart';

class SignInRepositoryImpl implements SignInRepository {
  SignInRepositoryImpl(this._datasource, this._secureStore);

  final SignInRemoteDatasource _datasource;
  final SecureStore _secureStore;

  @override
  Future<SignInSessionModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _datasource.signIn(email: email, password: password);
      await _secureStore.setAuthToken(session.accessToken);
      await _secureStore.setRefreshToken(session.refreshToken);
      return session;
    } on DioException catch (e) {
      throw e.error is Exception ? e.error as Exception : const ServerException();
    }
  }
}

final signInRemoteDatasourceProvider = Provider<SignInRemoteDatasource>((ref) {
  return SignInRemoteDatasource(ref.watch(dioClientProvider));
});

final signInRepositoryProvider = Provider<SignInRepository>((ref) {
  return SignInRepositoryImpl(
    ref.watch(signInRemoteDatasourceProvider),
    ref.watch(secureStoreProvider),
  );
});
