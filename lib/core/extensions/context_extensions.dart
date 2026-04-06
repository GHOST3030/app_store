import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme properties
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Colors shortcut
  Color get primaryColor => theme.primaryColor;

  // Media Query properties
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  // Safe area helper
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
}
