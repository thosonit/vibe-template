import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/load_status.dart';
import '../../data/repositories/sign_in_repository_impl.dart';
import 'sign_in_state.dart';

/// Holds and mutates sign-in UI state, calls the repository interface
/// directly. Never imports anything from `data/` except the repository
/// provider — see architecture doc's Layering section.
class SignInViewModel extends Notifier<SignInState> {
  @override
  SignInState build() => const SignInState();

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(status: LoadStatus.loading);

    try {
      final repository = ref.read(signInRepositoryProvider);
      await repository.signIn(email: email, password: password);
      state = state.copyWith(status: LoadStatus.success);
    } catch (error) {
      state = state.copyWith(
        status: LoadStatus.failure,
        failure: _mapToFailure(error),
      );
    }
  }

  Failure _mapToFailure(Object error) {
    return switch (error) {
      UnauthorizedException() => const UnauthorizedFailure(),
      NetworkException() => const NetworkFailure(),
      ServerException() => const ServerFailure(),
      DioException() => const NetworkFailure(),
      _ => const UnknownFailure(),
    };
  }
}

final signInViewModelProvider = NotifierProvider<SignInViewModel, SignInState>(
  SignInViewModel.new,
);
