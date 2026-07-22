/// DTO returned by the sign-in endpoint — doubles as the type passed up
/// to `presentation/` (no separate domain entity layer).
///
/// Swap the body for a `@freezed`/`@JsonSerializable` class once codegen
/// is wired up in the project; this hand-written version has no
/// generated-file dependency so the scaffold builds immediately.
class SignInSessionModel {
  const SignInSessionModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory SignInSessionModel.fromJson(Map<String, dynamic> json) {
    return SignInSessionModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userId: json['userId'] as String,
    );
  }

  final String accessToken;
  final String refreshToken;
  final String userId;

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'userId': userId,
      };
}
