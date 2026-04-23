import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/core/responsive/responsive.dart';
import '../logic/providers_auth.dart';
import 'package:new_auth/core/widgets/shared_text_field.dart';

class UpdatePasswordPage extends ConsumerStatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  ConsumerState<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends ConsumerState<UpdatePasswordPage> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    final formContent = _buildFormContent(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(context.l10n.updatePassword),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                Icon(Icons.lock_reset, size: 120, color: AppColors.authAccent),
                SizedBox(height: context.responsiveMargin),
                Text(
                  context.l10n.setNewPassword,
                  style: context.responsiveStyle(
                    Theme.of(context).textTheme.displaySmall?.copyWith(
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

  Widget _buildFormContent(BuildContext context) {
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
            if (!context.isDesktop) ...[
              Text(
                context.l10n.setNewPassword,
                style: context.responsiveStyle(Theme.of(context).textTheme.headlineMedium),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.responsivePadding),
            ],
            Text(
              context.l10n.enterYourNewPassword,
              style: TextStyle(fontSize: context.responsiveFontSize(14)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.responsiveMargin),
            SharedTextField(
              controller: _passwordController,
              hintText: context.l10n.newPassword,
              prefixIcon: Icons.lock,
              suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
              obscureText: _obscurePassword,
              onSuffixIconTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            SizedBox(height: context.responsivePadding * 1.5),
            ElevatedButton(
              onPressed: _updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.authButton,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: context.responsivePadding),
              ),
              child: Text(
                context.l10n.updatePassword,
                style: TextStyle(
                  fontSize: context.responsiveFontSize(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
