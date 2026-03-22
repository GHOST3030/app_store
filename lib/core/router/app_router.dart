import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_auth/features/product/presentation/pages/home_page.dart';
import '../../features/auth/logic/providers_auth.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/signup_page.dart';
import '../../features/auth/presentation/forgot_password_page.dart';
import '../../features/auth/presentation/update_password_page.dart';
import '../../features/auth/presentation/auth_gate.dart';
import 'router_notifier.dart';

/// Provides the GoRouter instance for the application.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const AuthGate()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/update-password',
        builder: (context, state) => const UpdatePasswordPage(),
      ),
      GoRoute(
        path: '/reset-callback',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: '/home', builder: (context, state) =>HomePage()),

      GoRoute(
        path: '/search',
        builder: (context, state) {
          return Text("lkj");
        },
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      final isAuth = authState.value != null;

      // Identify paths related to authentication logic screens (login, signup, forgot password)
      final isGoingToAuthPaths =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password';

      if (authState.isLoading) {
        // Do not redirect while authentication state is loading
        return null;
      }

      // Handle Supabase Deep Link Callbacks
      if (state.uri.host == 'reset-callback' ||
          state.matchedLocation == '/reset-callback') {
        final error = state.uri.queryParameters['error'];
      //  final errorDescription = state.uri.queryParameters['error_description'];
        if (error != null) {
        //  print("Password reset callback error: $error - $errorDescription");
          return '/login';
        }
        return '/update-password';
      }

      // 1. If user is NOT authenticated
      if (!isAuth) {
        if (isGoingToAuthPaths) {
          // They are allowed to be here, so do nothing!
          return null;
        }
        // Redirect to login if they try to access a protected route
        return '/login';
      }

      // 2. If user IS authenticated and attempting to access login/signup/forgot pages or the base route
      if (isAuth && (isGoingToAuthPaths || state.matchedLocation == '/')) {
        return '/home';
      }

      // No redirect otherwise
      return null;
    },
  );
});
