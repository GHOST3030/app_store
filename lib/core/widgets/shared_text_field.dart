import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SharedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final VoidCallback? onSuffixIconTap;

  const SharedTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: const TextStyle(color: AppColors.textMid),
        labelStyle: const TextStyle(color: AppColors.textMid),
        filled: true,
        fillColor: AppColors.inputFill,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMid) : null,
        suffixIcon: suffixIcon != null
            ? InkWell(
                onTap: onSuffixIconTap,
                borderRadius: BorderRadius.circular(20),
                child: Icon(suffixIcon, color: AppColors.textMid),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      obscureText: obscureText,
      enabled: enabled,
    );
  }
}
