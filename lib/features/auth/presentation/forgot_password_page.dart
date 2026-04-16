import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/core/responsive/responsive.dart';
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

    final content = _buildContent(context, isLoading);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ResponsiveBuilder(
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
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding * 1.5,
        vertical: context.responsiveMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: context.responsiveMargin),
          Text(
            context.l10n.forgetPassword,
            style: context.responsiveStyle(
              const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                height: 1.1,
              ),
            ),
          ),
          SizedBox(height: context.responsiveMargin),
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
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding,
                  vertical: context.responsivePadding,
                ),
              ),
            ),
          ),
          SizedBox(height: context.responsivePadding),
          RichText(
            text: TextSpan(
              text: '* ',
              style: TextStyle(
                color: AppColors.error,
                fontSize: context.responsiveFontSize(14),
              ),
              children: [
                TextSpan(
                  text: context.l10n.willSendMessageToSetPassword,
                  style: TextStyle(
                    color: AppColors.textMid,
                    fontSize: context.responsiveFontSize(14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.responsiveMargin),
          SizedBox(
            width: double.infinity,
            height: context.isDesktop ? 70 : (context.isTablet ? 65 : 60),
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
                      style: TextStyle(
                        fontSize: context.responsiveFontSize(22),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
