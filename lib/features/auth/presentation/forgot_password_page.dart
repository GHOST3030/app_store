import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/constants/app_strings.dart';
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
              const Text(
                AppStrings.forgetPassword,
                style: TextStyle(
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
                  decoration: const InputDecoration(
                    hintText: AppStrings.enterYourEmailAddress,
                    hintStyle: TextStyle(color: AppColors.textMid),
                    prefixIcon: Icon(
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
                text: const TextSpan(
                  text: '* ',
                  style: TextStyle(color: AppColors.error, fontSize: 14),
                  children: [
                    TextSpan(
                      text: AppStrings.willSendMessageToSetPassword,
                      style: TextStyle(color: AppColors.textMid, fontSize: 14),
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
                                  redirectTo: AppStrings.supabaseUriResetPassword,
                                );
                            if (context.mounted) {
                              _showMessage(AppStrings.resetInstructionsSent);
                            }
                          } else {
                            _showMessage(
                              AppStrings.pleaseEnterYourEmail,
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
                      : const Text(
                          AppStrings.submit,
                          style: TextStyle(
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
