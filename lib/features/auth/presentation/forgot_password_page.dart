import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/entities/app_user.dart';
import '../logic/providers_auth.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        _showMessage(next.error.toString(), isError: true);
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter your email address and we will send you a password reset link.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
              ),
              const SizedBox(height: 24),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    if (email.isNotEmpty) {
                      // Pass redirect deep link matching your URL scheme
                      await ref.read(authControllerProvider.notifier).resetPassword(
                        email,
                        redirectTo: 'io.supabase.flutter://reset-callback',
                      );
                      if (context.mounted) {
                        _showMessage('Password reset instructions have been sent to your email.');
                      
                      }
                    } else {
                      _showMessage('Please enter your email', isError: true);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Send Reset Link', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back to Login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
