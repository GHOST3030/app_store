import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import '../domain/entities/app_user.dart';
import '../logic/providers_auth.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        _showError(next.error.toString());
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
                context.l10n.createAnAccount,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      height: 1.2,
                    ),
              ),
              const SizedBox(height: 48),

              // Email Field
              _SignupInputField(
                controller: _emailController,
                hintText: context.l10n.usernameOrEmail,
                prefixIcon: Icons.person,
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),

              // Password Field
              _SignupInputField(
                controller: _passwordController,
                hintText: context.l10n.password,
                prefixIcon: Icons.lock,
                suffixIcon: Icons.visibility,
                obscureText: true,
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              _SignupInputField(
                controller: _confirmPasswordController,
                hintText: context.l10n.confirmPassword,
                prefixIcon: Icons.lock,
                suffixIcon: Icons.visibility,
                obscureText: true,
                enabled: !isLoading,
              ),

              const SizedBox(height: 24),

              // Terms and Conditions text
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: AppColors.textMid, fontSize: 13, height: 1.5),
                  children: [
                    TextSpan(text: context.l10n.byClickingThe),
                    TextSpan(text: context.l10n.register, style: const TextStyle(color: AppColors.authAccent)),
                    TextSpan(text: context.l10n.agreeToPublicOffer),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Create Account Button
              if (isLoading)
                const Center(child: CircularProgressIndicator(color: AppColors.authAccent))
              else
                ElevatedButton(
                  onPressed: () async {
                    final usernameOrEmail = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final confirmPassword = _confirmPasswordController.text.trim();
                    
                    if (usernameOrEmail.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                      _showError(context.l10n.pleaseFillInAllFields);
                    } else if (password != confirmPassword) {
                      _showError(context.l10n.passwordsDoNotMatch);
                    } else {
                      final isEmail = usernameOrEmail.contains('@') && usernameOrEmail.contains('.');
                      
                      if (isEmail) {
                        await ref.read(authControllerProvider.notifier).signUp(usernameOrEmail, password);
                      } else {
                        final sanitizedUsername = usernameOrEmail.replaceAll(' ', '').toLowerCase();
                        final dummyEmail = '$sanitizedUsername@placeholder.app.com';
                        await ref.read(authControllerProvider.notifier).signUp(dummyEmail, password, username: usernameOrEmail);
                      }

                      if (!context.mounted) return;
                      final currentState = ref.read(authControllerProvider);
                      if (!currentState.hasError) {
                         if (currentState.value == null) {
                           _showSuccess(context.l10n.verifyAccountToLogin);
                           context.go('/login');
                         }
                      }
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
                    context.l10n.createAccount,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 48),

              // Social Login OR Divider
              Align(
                alignment: Alignment.center,
                child: Text(
                  context.l10n.orContinueWith,
                  style: const TextStyle(color: AppColors.textMid, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 24),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialSignupButton(
                    fallbackIcon: Icons.g_mobiledata,
                    color: AppColors.error,
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).loginWithGoogle();
                    },
                  ),
                  const SizedBox(width: 20),
                  _SocialSignupButton(
                    fallbackIcon: Icons.apple,
                    color: AppColors.black,
                    onPressed: () {
                      // Apple logic
                    },
                  ),
                  const SizedBox(width: 20),
                  _SocialSignupButton(
                    fallbackIcon: Icons.facebook,
                    color: Colors.blue,
                    onPressed: () {
                      // Facebook logic
                    },
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.iAlreadyHaveAnAccount,
                    style: const TextStyle(color: AppColors.textMid, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      context.l10n.login,
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

// ─── Reusable signup input field ──────────────────────────────────────────────

class _SignupInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool enabled;

  const _SignupInputField({
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        obscureText: obscureText,
        enabled: enabled,
      ),
    );
  }
}

// ─── Social signup button ─────────────────────────────────────────────────────

class _SocialSignupButton extends StatelessWidget {
  final IconData fallbackIcon;
  final Color color;
  final VoidCallback onPressed;

  const _SocialSignupButton({
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
