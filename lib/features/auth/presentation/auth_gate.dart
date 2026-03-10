import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/providers_auth.dart';

/// The [AuthGate] acts as an initial loading screen.
/// Since GoRouter is handling the redirection based on authentication state,
/// this widget simply displays a spinner while the initial authentication state is being evaluated.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // If we are strictly relying on GoRouter redirect, we mostly see this briefly.
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // In case there is a delay before GoRouter kicks in
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
