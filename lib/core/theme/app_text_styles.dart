import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  // Display Large
  static TextStyle displayLarge(BuildContext context) => TextStyle(
        fontSize: _getResponsiveSize(context, 32, 40, 48),
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      );

  // Title
  static TextStyle title(BuildContext context) => TextStyle(
        fontSize: _getResponsiveSize(context, 16, 18, 20),
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      );

  // Body
  static TextStyle body(BuildContext context) => TextStyle(
        fontSize: _getResponsiveSize(context, 13, 14, 16),
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      );

  // Body Bold
  static TextStyle bodyBold(BuildContext context) => TextStyle(
        fontSize: _getResponsiveSize(context, 13, 14, 16),
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      );

  // Caption
  static TextStyle caption(BuildContext context) => TextStyle(
        fontSize: _getResponsiveSize(context, 11, 12, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.textMid,
      );

  // Caption Bold
  static TextStyle captionBold(BuildContext context) => TextStyle(
        fontSize: _getResponsiveSize(context, 11, 12, 14),
        fontWeight: FontWeight.w600,
        color: AppColors.textMid,
      );

  // Helper function to scale text fluidly
  static double _getResponsiveSize(
      BuildContext context, double phone, double tablet, double desktop) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 600) return phone;
    if (width < 900) return tablet;
    return desktop;
  }
}
