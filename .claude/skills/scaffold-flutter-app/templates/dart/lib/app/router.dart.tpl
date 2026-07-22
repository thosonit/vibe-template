import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/sign_in/presentation/pages/sign_in_page.dart';

/// Route paths as constants — never magic strings scattered across features.
class AppRoutes {
  AppRoutes._();

  static const String signIn = '/sign-in';
}

/// Central `go_router` config. Add new routes here as features land;
/// wrap with `ShellRoute` once the app needs a persistent shell (bottom
/// nav, side drawer) — not needed yet for a single sign-in screen.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.signIn,
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        name: AppRoutes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
    ],
  );
});
