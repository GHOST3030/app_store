import 'package:flutter/material.dart';
import 'responsive_utils.dart';

class ResponsiveSpacing {
  static double padding(BuildContext context) {
    if (context.isDesktop) return 32.0;
    if (context.isTablet) return 24.0;
    return 16.0;
  }

  static double margin(BuildContext context) {
    if (context.isDesktop) return 48.0;
    if (context.isTablet) return 32.0;
    return 16.0;
  }

  static double get scalingFactor {
    return 1.0;
  }
}

extension ResponsiveSpacingContext on BuildContext {
  double get responsivePadding => ResponsiveSpacing.padding(this);
  double get responsiveMargin => ResponsiveSpacing.margin(this);
}
