import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/constants/app_strings.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import '../logic/providers_auth.dart';

class UpdatePasswordPage extends ConsumerStatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  ConsumerState<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends ConsumerState<UpdatePasswordPage> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  Future<void> _updatePassword() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty || password.length < 6) {
      _showMessage(AppStrings.passwordMustBeAtLeast6, isError: true);
      return;
    }

    try {
      await ref.read(authControllerProvider.notifier).updatePassword(password);
      
      final authState = ref.read(authControllerProvider);
      
      if (authState.hasError) {
        _showMessage(authState.error.toString(), isError: true);
      } else {
        _showMessage(AppStrings.passwordSuccessfully);
        
        await ref.read(authControllerProvider.notifier).logout();
      }
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.updatePassword)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.setNewPassword,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.enterYourNewPassword,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: AppStrings.newPassword,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updatePassword,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(AppStrings.updatePassword, style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
