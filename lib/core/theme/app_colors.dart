import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand Colors
  static const primary = Color(0xFFE91E63);
  static const primaryLight = Color(0xFFFCE4EC);
  static const secondary = Color(0xFF1A237E);

  // Status & Feedback Colors
  static const starYellow = Color(0xFFFFC107);
  static const badge = Color(0xFFFF5252);
  static const priceOld = Color(0xFF9E9E9E);
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFF44336);

  // Texts
  static const textDark = Color(0xFF212121);
  static const textMid = Color(0xFF757575);
  static const textLight = Color(0xFFBDBDBD);

  // Backgrounds & Lines
  static const bgGrey = Color(0xFFF5F5F5);
  static const divider = Color(0xFFEEEEEE);
  static const white = Colors.white;
  static const black = Colors.black;

  // Categories Colors
  static const catBeauty = Color(0xFFFF80AB);
  static const catFashion = Color(0xFFE91E63);
  static const catKids = Color(0xFF42A5F5);
  static const catMens = Color(0xFF5C6BC0);
  static const catWomens = Color(0xFFAB47BC);

  // Auth Colors
  static const authAccent = Color(0xFFE94057);
  static const authButton = Color(0xFFF33D5B);
  static const inputFill = Color(0xFFF3F3F3);

  // Misc Banner Specific Colors
  static const summerSaleIcon = Color(0xFFE65100);
  static const summerSaleSub = Color(0xFFBF360C);
  static const bannerBorder = Color(0xFFFFD54F);
  static const specialOfferIcon = Color(0xFFFF6F00);

  // Gradients
  static const promoBannerGradient = LinearGradient(
    colors: [Color(0xFFFF80AB), Color(0xFFE91E63)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const promoNewArrivalsGradient = LinearGradient(
    colors: [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const promoFlashSaleGradient = LinearGradient(
    colors: [Color(0xFFEF6C00), Color(0xFFFF9800)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
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

  static const summerSaleGradient = LinearGradient(
    colors: [Color(0xFFFFF8E1), Color(0xFFFFCC02)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const sponsoredGradient = LinearGradient(
    colors: [Color(0xFF37474F), Color(0xFF263238)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const specialOffersGradient = LinearGradient(
    colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
  );

  static const flatHeelsGradient = LinearGradient(
    colors: [Color(0xFFF8BBD9), Color(0xFFE91E63)],
  );
}
