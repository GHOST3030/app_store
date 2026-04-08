import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/app_user.dart';
import '../logic/providers_auth.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  late String errmessage = '';
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );

    errmessage = message;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to AuthState updates (specifically errors)
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        final error = next.error;
        if (error is AuthException) {
          _showError(error.message);
        } else {
          _showError(error.toString());
        }
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                context.l10n.welcomeBack,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 48),

              // Email Field
              _AuthInputField(
                controller: _emailController,
                hintText: context.l10n.usernameOrEmail,
                prefixIcon: Icons.person,
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),

              // Password Field
              _AuthInputField(
                controller: _passwordController,
                hintText: context.l10n.password,
                prefixIcon: Icons.lock,
                suffixIcon: Icons.visibility,
                obscureText: true,
                enabled: !isLoading,
              ),

              const SizedBox(height: 12),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    context.l10n.forgotPasswordAsk,
                    style: const TextStyle(
                      color: AppColors.authAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Login Button
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.authAccent),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    final usernameOrEmail = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    if (usernameOrEmail.isNotEmpty && password.isNotEmpty) {
                      final isEmail =
                          usernameOrEmail.contains('@') &&
                          usernameOrEmail.contains('.');
                      final sanitizedUsername = usernameOrEmail
                          .replaceAll(' ', '')
                          .toLowerCase();
                      final emailToUse = isEmail
                          ? usernameOrEmail
                          : '$sanitizedUsername@placeholder.app.com';
                      ref
                          .read(authControllerProvider.notifier)
                          .login(emailToUse, password);
                    } else {
                      _showError(context.l10n.pleaseFillInAllFields);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.authButton,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    context.l10n.login,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),

              const SizedBox(height: 48),

              // Social Login OR Divider
              Align(
                alignment: Alignment.center,
                child: Text(
                  context.l10n.orContinueWith,
                  style: const TextStyle(
                    color: AppColors.textMid,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialLoginButton(
                    icon:
                        'assets/google.png',
                    fallbackIcon: Icons.g_mobiledata,
                    color: AppColors.error,
                    onPressed: () {
                      ref
                          .read(authControllerProvider.notifier)
                          .loginWithGoogle();
                    },
                  ),
                  const SizedBox(width: 20),
                  _SocialLoginButton(
                    icon: 'assets/apple.png',
                    fallbackIcon: Icons.apple,
                    color: AppColors.black,
                    onPressed: () {
                      // Apple logic
                    },
                  ),
                  const SizedBox(width: 20),
                  _SocialLoginButton(
                    icon: 'assets/facebook.png',
                    fallbackIcon: Icons.facebook,
                    color: Colors.blue,
                    onPressed: () {
                      // Facebook logic
                    },
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.createAnAccountText,
                    style: const TextStyle(
                      color: AppColors.textMid,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/signup'),
                    child: Text(
                      context.l10n.signUp,
                      style: const TextStyle(
                        color: AppColors.authAccent,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.authAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable auth input field ─────────────────────────────────────────────────

class _AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool enabled;

  const _AuthInputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textLight),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textMid),
          border: InputBorder.none,
          prefixIcon: Icon(prefixIcon, color: AppColors.textMid),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: AppColors.textMid)
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        obscureText: obscureText,
        enabled: enabled,
      ),
    );
  }
}

// ─── Social login button ─────────────────────────────────────────────────────

class _SocialLoginButton extends StatelessWidget {
  final String icon;
  final IconData fallbackIcon;
  final Color color;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.fallbackIcon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.authAccent.withValues(alpha: 0.5)),
          color: AppColors.authAccent.withValues(alpha: 0.05),
        ),
        child: Center(
          child: Icon(fallbackIcon, size: 32, color: color),
        ),
      ),
    );
  }
}
