import 'package:dio/dio.dart';

import '../models/sign_in_session_model.dart';

/// Raw I/O only — wraps the Dio call. No retrofit client generated yet;
/// swap the body for a generated `SignInApiClient` once `retrofit` codegen
/// is set up for the project (see architecture doc's Network section).
class SignInRemoteDatasource {
  SignInRemoteDatasource(this._dio);

  final Dio _dio;

  Future<SignInSessionModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/sign-in',
      data: {'email': email, 'password': password},
    );
    return SignInSessionModel.fromJson(response.data!);
  }
}
