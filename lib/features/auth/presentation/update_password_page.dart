import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/core/responsive/responsive.dart';
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
      _showMessage(context.l10n.passwordMustBeAtLeast6, isError: true);
      return;
    }

    try {
      await ref.read(authControllerProvider.notifier).updatePassword(password);
      
      final authState = ref.read(authControllerProvider);
      
      if (authState.hasError) {
        _showMessage(authState.error.toString(), isError: true);
      } else {
        _showMessage(context.l10n.passwordSuccessfully);
        await ref.read(authControllerProvider.notifier).logout();
      }
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.updatePassword)),
      body: ResponsiveBuilder(
        mobile: content,
        tablet: Center(
          child: SizedBox(
            width: 500,
            child: content,
          ),
        ),
        desktop: Center(
          child: SizedBox(
            width: 600,
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsivePadding * 1.5,
          vertical: context.responsiveMargin,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.setNewPassword,
              style: context.responsiveStyle(Theme.of(context).textTheme.headlineMedium),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.responsivePadding),
            Text(
              context.l10n.enterYourNewPassword,
              style: TextStyle(fontSize: context.responsiveFontSize(14)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.responsiveMargin),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: context.l10n.newPassword,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                  vertical: context.responsivePadding,
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: context.responsivePadding * 1.5),
            ElevatedButton(
              onPressed: _updatePassword,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: context.responsivePadding),
              ),
              child: Text(
                context.l10n.updatePassword,
                style: TextStyle(fontSize: context.responsiveFontSize(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
