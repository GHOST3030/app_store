import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
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
        backgroundColor: isError ? AppColors.error : AppColors.success,
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
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Big Bold Header
              Text(
                context.l10n.forgetPassword,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 40),
              // Styled Text Field
              Container(
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.textLight),
                ),
                child: TextField(
                  controller: _emailController,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: context.l10n.enterYourEmailAddress,
                    hintStyle: const TextStyle(color: AppColors.textMid),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.textDark,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Subtext with Asterisk
              RichText(
                text: TextSpan(
                  text: '* ',
                  style: const TextStyle(color: AppColors.error, fontSize: 14),
                  children: [
                    TextSpan(
                      text: context.l10n.willSendMessageToSetPassword,
                      style: const TextStyle(color: AppColors.textMid, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final email = _emailController.text.trim();
                          if (email.isNotEmpty) {
                            await ref
                                .read(authControllerProvider.notifier)
                                .resetPassword(
                                  email,
                                  redirectTo: context.l10n.supabaseUriResetPassword,
                                );
                            if (context.mounted) {
                              _showMessage(context.l10n.resetInstructionsSent);
                            }
                          } else {
                            _showMessage(
                              context.l10n.pleaseEnterYourEmail,
                              isError: true,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.authButton,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : Text(
                          context.l10n.submit,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
