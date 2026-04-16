import 'package:flutter/material.dart';
import 'responsive_utils.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop;
    } else if (context.isTablet && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}
