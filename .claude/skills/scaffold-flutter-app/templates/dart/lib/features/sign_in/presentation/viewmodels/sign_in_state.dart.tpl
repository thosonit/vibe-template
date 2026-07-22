import '../../../../core/errors/failure.dart';
import '../../../../core/utils/load_status.dart';

/// Immutable UI state for the sign-in screen — Pattern 2 (LoadStatus enum)
/// from the architecture doc, since sign-in is a single submit action with
/// its own status rather than a screen whose primary job is loading data.
class SignInState {
  const SignInState({
    this.status = LoadStatus.initial,
    this.failure,
  });

  final LoadStatus status;
  final Failure? failure;

  bool get isLoading => status == LoadStatus.loading;
  bool get isSuccess => status == LoadStatus.success;
  bool get isFailure => status == LoadStatus.failure;

  SignInState copyWith({LoadStatus? status, Failure? failure}) {
    return SignInState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
