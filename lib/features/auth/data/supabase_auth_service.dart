import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/app_user.dart';
import 'auth_repository.dart';

/// Concrete implementation of [AuthRepository] using the official Supabase SDK.
///
/// Methods may throw [AuthException] or other exceptions directly from the
/// Supabase SDK.
class SupabaseAuthService implements AuthRepository {
  final SupabaseClient _supabaseClient;

  SupabaseAuthService(this._supabaseClient);

  @override
  Future<AppUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? username,
  }) async {
    return runAuth(() async {
      await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: username != null && username.isNotEmpty
            ? {'username': username}
            : null,
      );
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw const AuthException('Signup failed');
      }
      return AppUser.fromSupabase(user);
    });
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return runAuth(() async {
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw const AuthException('Login failed');
      }
      return AppUser.fromSupabase(user);
    });
  }

  @override
  Future<void> signInWithGoogle() async {
    return runAuth(() async {
      await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    });
  }

  @override
  Future<void> signOut() async {
    return runAuth(() async {
      await _supabaseClient.auth.signOut();
    });
  }

  @override
  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    return runAuth(() async {
      await _supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
    });
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    return runAuth(
      () => _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      ),
    );
  }

  @override
  AppUser? get currentUser {
    final user = _supabaseClient.auth.currentUser;
    return user != null ? AppUser.fromSupabase(user) : null;
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      return user != null ? AppUser.fromSupabase(user) : null;
    });
  }

  Future<T> runAuth<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthApiException catch (e) {
      // الرسالة الأصلية من Supabase
     // print("AuthApiException in SupabaseAuthService: ${e.message}");
      throw e.message;
    } on AuthException catch (e) {
    //  print("Unexpected error in SupabaseAuthService: $e");
      throw e.message; // إذا كانت AuthException مسبقاً
    } catch (e) {
     // print("Unexpected error in SupabaseAuthService: $e");
      // أي خطأ غير متوقع
      throw e.toString();
    }
  }
}
