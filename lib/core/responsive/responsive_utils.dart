import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';

class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  double get width => MediaQuery.sizeOf(context).width;
  double get height => MediaQuery.sizeOf(context).height;

  bool get isMobile => width < ResponsiveBreakpoints.mobile;
  bool get isTablet => width >= ResponsiveBreakpoints.mobile && width < ResponsiveBreakpoints.tablet;
  bool get isDesktop => width >= ResponsiveBreakpoints.tablet;
}

extension ResponsiveContext on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  double get width => responsive.width;
  double get height => responsive.height;
}
