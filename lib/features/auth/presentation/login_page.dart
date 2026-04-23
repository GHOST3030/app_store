import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:new_auth/core/responsive/responsive.dart';
import '../domain/entities/app_user.dart';
import '../logic/providers_auth.dart';
import 'package:new_auth/core/widgets/shared_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late String errmessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
    errmessage = message;
  }

  @override
  Widget build(BuildContext context) {
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

    final formContent = _buildFormContent(context, isLoading);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ResponsiveBuilder(
          mobile: _buildMobile(context, formContent),
          tablet: _buildTablet(context, formContent),
          desktop: _buildDesktop(context, formContent),
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context, Widget formContent) {
    return formContent;
  }

  Widget _buildTablet(BuildContext context, Widget formContent) {
    return Center(
      child: Card(
        elevation: 8,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.all(context.responsivePadding * 2),
        child: Container(
          width: 500,
          padding: EdgeInsets.all(context.responsivePadding * 1.5),
          child: formContent,
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, Widget formContent) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: AppColors.authAccent.withValues(alpha: 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_person, size: 120, color: AppColors.authAccent),
                SizedBox(height: context.responsiveMargin),
                Text(
                  context.l10n.welcomeBack,
                  style: context.responsiveStyle(
                    Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: 500,
              child: formContent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!context.isDesktop) ...[
            SizedBox(height: context.responsiveMargin),
            Text(
              context.l10n.welcomeBack,
              style: context.responsiveStyle(
                Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(height: context.responsiveMargin * 1.5),
          ],
          SharedTextField(
            controller: _emailController,
            hintText: context.l10n.usernameOrEmail,
            prefixIcon: Icons.person,
            enabled: !isLoading,
          ),
          SizedBox(height: context.responsivePadding),
          SharedTextField(
            controller: _passwordController,
            hintText: context.l10n.password,
            prefixIcon: Icons.lock,
            suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
            obscureText: _obscurePassword,
            enabled: !isLoading,
            onSuffixIconTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          SizedBox(height: context.responsivePadding * 0.75),
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
          SizedBox(height: context.responsiveMargin),
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
                padding: EdgeInsets.symmetric(vertical: context.responsivePadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                context.l10n.login,
                style: TextStyle(
                  fontSize: context.responsiveFontSize(18),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(height: context.responsiveMargin * 1.5),
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
          SizedBox(height: context.responsiveMargin),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialLoginButton(
                icon: 'assets/google.png',
                fallbackIcon: Icons.g_mobiledata,
                color: AppColors.error,
                onPressed: () {
                  ref
                      .read(authControllerProvider.notifier)
                      .loginWithGoogle();
                },
              ),
              SizedBox(width: context.responsivePadding),
              _SocialLoginButton(
                icon: 'assets/apple.png',
                fallbackIcon: Icons.apple,
                color: AppColors.black,
                onPressed: () {},
              ),
              SizedBox(width: context.responsivePadding),
              _SocialLoginButton(
                icon: 'assets/facebook.png',
                fallbackIcon: Icons.facebook,
                color: Colors.blue,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: context.responsiveMargin * 1.5),
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
    );
  }
}

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
    final size = context.isDesktop ? 80.0 : (context.isTablet ? 70.0 : 60.0);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.authAccent.withValues(alpha: 0.5),
          ),
          color: AppColors.authAccent.withValues(alpha: 0.05),
        ),
        child: Center(
          child: Icon(fallbackIcon, size: size * 0.5, color: color),
        ),
      ),
    );
  }
}
