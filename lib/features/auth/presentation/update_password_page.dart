import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _updatePassword() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty || password.length < 6) {
      _showMessage('Password must be at least 6 characters long', isError: true);
      return;
    }

    try {
      await ref.read(authControllerProvider.notifier).updatePassword(password);
      
      // We look at the latest state to see if there was an error emitted during the update process
      final authState = ref.read(authControllerProvider);
      
      if (authState.hasError) {
        _showMessage(authState.error.toString(), isError: true);
      } else {
        _showMessage('Password updated successfully!');
        
        // Log the user out so they are forced to log in with the new password
        await ref.read(authControllerProvider.notifier).logout();
        
   
      }
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Set New Password',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please enter your new password below.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
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
                  child: Text('Update Password', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
