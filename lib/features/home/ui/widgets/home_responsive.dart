import 'package:flutter/material.dart';

/// Responsive breakpoints & adaptive sizing helper.
/// Usage: final r = HomeResponsive.of(context);
class HomeResponsive {
  HomeResponsive._(this._width, this._height);

  factory HomeResponsive.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return HomeResponsive._(size.width, size.height);
  }

  final double _width;
  final double _height;

  // ── Breakpoints ──────────────────────────────────────────────────────────
  bool get isPhone => _width < 600;
  bool get isTablet => _width >= 600 && _width < 900;
  bool get isDesktop => _width >= 900;

  // ── Horizontal padding ───────────────────────────────────────────────────
  double get hPad => isPhone ? 16.0 : isTablet ? 28.0 : 48.0;

  // ── Grid columns ─────────────────────────────────────────────────────────
  int get productGridCols => isPhone ? 2 : isTablet ? 3 : 4;

  // ── Card dimensions ───────────────────────────────────────────────────────
  /// Width of a product card in a horizontal list
  double get cardWidth {
    if (isPhone) return _width * 0.42;
    if (isTablet) return _width * 0.28;
    return _width * 0.20;
  }

  double get cardImageHeight => cardWidth * 0.75;

  /// Grid card aspect ratio (w/h)
  double get gridCardAspectRatio => isPhone ? 0.70 : 0.72;

  double get gridSpacing => isPhone ? 12.0 : 16.0;

  // ── Banner heights ────────────────────────────────────────────────────────
  double get promoBannerHeight => isPhone ? 158.0 : isTablet ? 200.0 : 240.0;
  double get dealBannerHeaderHeight => isPhone ? 58.0 : 68.0;
  double get dealListHeight => cardImageHeight + 120;
  double get specialOfferHeight => isPhone ? 88.0 : 100.0;
  double get flatHeelsHeight => isPhone ? 100.0 : 120.0;
  double get hotSaleHeight => isPhone ? 118.0 : 140.0;
  double get sponsoredHeight => isPhone ? 156.0 : 200.0;

  // ── Typography ────────────────────────────────────────────────────────────
  double get titleFontSize => isPhone ? 16.0 : 18.0;
  double get bodyFontSize => isPhone ? 13.0 : 14.0;
  double get captionFontSize => isPhone ? 11.0 : 12.0;
  double get priceFontSize => isPhone ? 14.0 : 15.0;

  // ── Category bubble ───────────────────────────────────────────────────────
  double get categoryBubbleSize => isPhone ? 56.0 : 68.0;
  double get categoryIconSize => isPhone ? 24.0 : 28.0;
  double get categoryListHeight => isPhone ? 85.0 : 100.0;
  double get categorySpacing => isPhone ? 18.0 : 24.0;

  // ── Misc ──────────────────────────────────────────────────────────────────
  double get searchBarHeight => isPhone ? 46.0 : 52.0;
  double get bottomNavHeight => isPhone ? 68.0 : 76.0;
  double get sectionGap => isPhone ? 24.0 : 32.0;
  double get borderRadius => isPhone ? 12.0 : 16.0;
}
