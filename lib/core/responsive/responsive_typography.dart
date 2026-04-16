import 'package:flutter/material.dart';
import 'responsive_utils.dart';

class ResponsiveTypography {
  static double getScale(BuildContext context) {
    if (context.isDesktop) return 1.25;
    if (context.isTablet) return 1.1;
    return 1.0;
  }

  static double fontSize(BuildContext context, double baseSize) {
    return baseSize * getScale(context);
  }
}

extension ResponsiveTypographyContext on BuildContext {
  double responsiveFontSize(double baseSize) => ResponsiveTypography.fontSize(this, baseSize);

  TextStyle? responsiveStyle(TextStyle? style) {
    if (style == null) return null;
    return style.copyWith(
      fontSize: style.fontSize != null ? responsiveFontSize(style.fontSize!) : null,
    );
  }
}
