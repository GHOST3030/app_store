import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      SnackBar(content: Text(message), backgroundColor: Colors.red),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Welcome\nBack!',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 48),

              // Email Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Username or Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  enabled: !isLoading,
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  obscureText: true,
                  enabled: !isLoading,
                ),
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
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFFE94057),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

           

              // Login Button
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE94057)),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    final usernameOrEmail = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    if (usernameOrEmail.isNotEmpty && password.isNotEmpty) {
                      // Basic check if the input is an email
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
                      _showError('Please fill in all fields');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF33D5B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),

              const SizedBox(height: 48),

              // Social Login OR Divider
              const Align(
                alignment: Alignment.center,
                child: Text(
                  '- OR Continue with -',
                  style: TextStyle(
                    color: Colors.grey,
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
                        'assets/google.png', // Fallback to icons if assets aren't there
                    fallbackIcon: Icons.g_mobiledata,
                    color: Colors.red,
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
                    color: Colors.black,
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
                  const Text(
                    'Create An Account ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/signup'),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFFE94057),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFE94057),
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
          border: Border.all(color: const Color(0xFFE94057).withOpacity(0.5)),
          color: const Color(0xFFE94057).withOpacity(0.05),
        ),
        child: Center(
          // Normally Image.asset(icon) would be used, but using Icon for fallback
          child: Icon(fallbackIcon, size: 32, color: color),
        ),
      ),
    );
  }
}
