import 'package:flutter/material.dart';

abstract final class HomeColors {
  static const primary = Color(0xFFE91E63);
  static const primaryLight = Color(0xFFFCE4EC);
  static const starYellow = Color(0xFFFFC107);
  static const badge = Color(0xFFFF5252);
  static const priceOld = Color(0xFF9E9E9E);
  static const textDark = Color(0xFF212121);
  static const textMid = Color(0xFF757575);
  static const bgGrey = Color(0xFFF5F5F5);
  static const divider = Color(0xFFEEEEEE);
  static const white = Colors.white;

  static const promoBannerGradient = LinearGradient(
    colors: [Color(0xFFFF80AB), Color(0xFFE91E63)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const dealBannerGradient = LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const trendingGradient = LinearGradient(
    colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
