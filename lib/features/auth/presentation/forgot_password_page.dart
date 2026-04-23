import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/core/responsive/responsive.dart';
import '../domain/entities/app_user.dart';
import '../logic/providers_auth.dart';
import 'package:new_auth/core/widgets/shared_text_field.dart';

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

    final formContent = _buildFormContent(context, isLoading);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(context.l10n.forgetPassword),
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
                Icon(Icons.mark_email_read, size: 120, color: AppColors.authAccent),
                SizedBox(height: context.responsiveMargin),
                Text(
                  context.l10n.forgetPassword,
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

  Widget _buildFormContent(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding * 1.5,
        vertical: context.responsiveMargin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!context.isDesktop) ...[
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
          ],
          SharedTextField(
            controller: _emailController,
            enabled: !isLoading,
            hintText: context.l10n.enterYourEmailAddress,
            prefixIcon: Icons.email_outlined,
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
