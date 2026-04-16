// profile/ui/widgets/change_password_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/core/widgets/shared_text_field.dart';
import '../../logic/entities/profile_entity.dart';
import '../../logic/providers/profile_providers.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  final ProfileEntity currentProfile;

  const ChangePasswordDialog({super.key, required this.currentProfile});

  @override
  ConsumerState<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.white,
      title: const Row(
        children: [
          Icon(Icons.lock_reset, color: AppColors.primary),
          SizedBox(width: 8),
          Text(
            'Change Password',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SharedTextField(
              controller: _newPasswordController,
              labelText: 'New Password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureNew,
              suffixIcon: _obscureNew ? Icons.visibility_off : Icons.visibility,
              onSuffixIconTap: () => setState(() => _obscureNew = !_obscureNew),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SharedTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirm,
              suffixIcon: _obscureConfirm ? Icons.visibility_off : Icons.visibility,
              onSuffixIconTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: AppColors.textMid),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final updatedProfile = ProfileEntity(
                id: widget.currentProfile.id,
                email: widget.currentProfile.email,
                password: _newPasswordController.text,
                address: widget.currentProfile.address,
                city: widget.currentProfile.city,
                country: widget.currentProfile.country,
                pincode: widget.currentProfile.pincode,
                bankAccountNumber: widget.currentProfile.bankAccountNumber,
                accountHolderName: widget.currentProfile.accountHolderName,
                ifscCode: widget.currentProfile.ifscCode,
                createdAt: widget.currentProfile.createdAt,
              );
              ref.read(profileNotifierProvider.notifier).updateProfile(updatedProfile);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password changed successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Update'),
        ),
      ],
    );
  }
}