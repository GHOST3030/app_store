import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/network/supabase_client_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/app_user.dart';
import '../data/auth_repository.dart';
import '../data/supabase_auth_service.dart';
import 'auth_controller.dart';

/// Exposes the global [SupabaseClient] instance.

/// Exposes the [AuthRepository] implementation to the rest of the application.
/// It uses the [SupabaseAuthService] concrete implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseAuthService(supabaseClient);
});

/// The core authentication logic provider.
final authControllerProvider = AsyncNotifierProvider<AuthController, AppUser?>(
  AuthController.new,
);
