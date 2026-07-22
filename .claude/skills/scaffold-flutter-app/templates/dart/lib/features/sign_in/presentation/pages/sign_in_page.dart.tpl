import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/utils/load_status.dart';
import '../viewmodels/sign_in_viewmodel.dart';
import '../widgets/sign_in_form.dart';

/// Watches [signInViewModelProvider] and renders state only — no business
/// logic, no direct data source/repository access (see Layering section).
class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInViewModelProvider);

    ref.listen(signInViewModelProvider, (previous, next) {
      if (next.isFailure && next.failure != null) {
        context.showSnackBar(next.failure!.message);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SignInForm(
              isLoading: state.status == LoadStatus.loading,
              onSubmit: (email, password) {
                ref.read(signInViewModelProvider.notifier).signIn(
                      email: email,
                      password: password,
                    );
              },
            ),
          ),
        ),
      ),
    );
  }
}
