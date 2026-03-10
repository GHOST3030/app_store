import '../domain/entities/app_user.dart';

/// Abstract repository defining the authentication methods for the app.
/// This allows us to separate our core logic from the specific Supabase implementation if needed.
///
/// Methods may throw exceptions with messages from the backend (e.g. Supabase).
abstract class AuthRepository {
  /// Sign up a new user using email and password, with an optional username.
  ///
  /// Throws an exception if signup fails.
  Future<AppUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? username,
  });

  /// Log in an existing user using email and password.
  ///
  /// Throws an exception if signin fails.
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Google Sign In (Android/iOS/Web).
  Future<void> signInWithGoogle();

  /// Log out the current user.
  Future<void> signOut();

  /// Send a password reset email to the user.
  Future<void> resetPasswordForEmail(String email, {String? redirectTo});

  /// Update the password for the currently authenticated user.
  Future<void> updatePassword(String newPassword);

  /// Retrieve the currently authenticated user (if any).
  AppUser? get currentUser;

  /// Stream of authenticated user state changes.
  Stream<AppUser?> get authStateChanges;
}
