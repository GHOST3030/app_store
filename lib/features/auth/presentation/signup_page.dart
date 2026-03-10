import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Create an\naccount',
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  obscureText: true,
                  enabled: !isLoading,
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    hintText: 'ConfirmPassword',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  obscureText: true,
                  enabled: !isLoading,
                ),
              ),

              const SizedBox(height: 24),

              // Terms and Conditions text
              RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
                  children: [
                    TextSpan(text: 'By clicking the '),
                    TextSpan(text: 'Register', style: TextStyle(color: Color(0xFFE94057))),
                    TextSpan(text: ' button, you agree to the public offer'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Create Account Button
              if (isLoading)
                const Center(child: CircularProgressIndicator(color: Color(0xFFE94057)))
              else
                ElevatedButton(
                  onPressed: () async {
                    final usernameOrEmail = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final confirmPassword = _confirmPasswordController.text.trim();
                    
                    if (usernameOrEmail.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                      _showError('Please fill in all fields');
                    } else if (password != confirmPassword) {
                      _showError('Passwords do not match');
                    } else {
                      // Basic check if the input is an email
                      final isEmail = usernameOrEmail.contains('@') && usernameOrEmail.contains('.');
                      
                      if (isEmail) {
                        await ref.read(authControllerProvider.notifier).signUp(usernameOrEmail, password);
                      } else {
                        // User entered a username. We'll generate a dummy email for Supabase to use as the primary
                        // identifier, and save the actual username in the user metadata using the `username` parameter.
                        final sanitizedUsername = usernameOrEmail.replaceAll(' ', '').toLowerCase();
                        final dummyEmail = '$sanitizedUsername@placeholder.app.com';
                        await ref.read(authControllerProvider.notifier).signUp(dummyEmail, password, username: usernameOrEmail);
                      }

                      if (!context.mounted) return;
                      final currentState = ref.read(authControllerProvider);
                      if (!currentState.hasError) {
                         if (currentState.value == null) {
                           // Email verification is required by Supabase
                           _showSuccess('Account created! Please check your email and verify your account to log in.');
                           context.go('/login');
                         } else {
                           // User is authenticated! GoRouter handles the redirect to /home.
                         }
                      }
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
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 48),

              // Social Login OR Divider
              const Align(
                alignment: Alignment.center,
                child: Text(
                  '- OR Continue with -',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 24),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialSignupButton(
                    fallbackIcon: Icons.g_mobiledata,
                    color: Colors.red,
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).loginWithGoogle();
                    },
                  ),
                  const SizedBox(width: 20),
                  _SocialSignupButton(
                    fallbackIcon: Icons.apple,
                    color: Colors.black,
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
                  const Text(
                    'I Already Have an Account ',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: const Text(
                      'Login',
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
          border: Border.all(color: const Color(0xFFE94057).withOpacity(0.5)),
          color: const Color(0xFFE94057).withOpacity(0.05),
        ),
        child: Center(
          child: Icon(fallbackIcon, size: 32, color: color),
        ),
      ),
    );
  }
}
