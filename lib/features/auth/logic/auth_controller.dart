import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../domain/entities/app_user.dart';
import 'providers_auth.dart';

/// The [AuthController] manages the authentication logic and updates the Riverpod state.
class AuthController extends AsyncNotifier<AppUser?> {
  late final AuthRepository _authRepository;

  @override
  FutureOr<AppUser?> build() {
    _authRepository = ref.watch(authRepositoryProvider);

    final sub = _authRepository.authStateChanges.listen(
      (user) {
        state = AsyncData(user);
      },
      onError: (error, st) {
        state = AsyncError(error, st);
      },
    );

    ref.onDispose(sub.cancel);

    return _authRepository.currentUser;
  }

  Future<void> signUp(String email, String password, {String? username}) async {
    return guard(() async {
      await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
      );
    });
  }

  Future<void> login(String email, String password) async {
    return guard(() async {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> loginWithGoogle() async {
    return guard(() async {
      await _authRepository.signInWithGoogle();
    });
  }

  Future<void> logout() async {
    return guard(() async {
      await _authRepository.signOut();
    });
  }

  Future<void> resetPassword(String email, {String? redirectTo}) async {
    return guard(() async {
      await _authRepository.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
      // Keep the current user state unchanged after requesting password reset

      // Keep the current user state unchanged after requesting password reset

      // After requesting password reset, we can keep the user state unchanged
    });
  }

  Future<void> updatePassword(String newPassword) async {
    return guard(() async {
      await _authRepository.updatePassword(newPassword);

      // After password update, we can refresh the user data
    });
  }

  Future<void> guard(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = AsyncData(state.value);
    } catch (e, st) {
      //    print("Error in AuthController: $e");
      state = AsyncError(e, st);
    }
  }
}
