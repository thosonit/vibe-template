import '../../data/models/sign_in_session_model.dart';

/// Contract `presentation/` codes against — `data/` implements it.
abstract class SignInRepository {
  Future<SignInSessionModel> signIn({
    required String email,
    required String password,
  });
}
