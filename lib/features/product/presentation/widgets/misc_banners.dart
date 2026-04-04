import 'package:flutter/material.dart';
import 'export_allthings.dart';

class HotSummerSaleBanner extends StatelessWidget {
  const HotSummerSaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      child: Container(
        height: r.hotSaleHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFCC02)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(r.borderRadius),
          border: Border.all(color: const Color(0xFFFFD54F)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              top: -15,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HomeColors.white.withOpacity(0.25),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(r.isPhone ? 16 : 20),
              child: Row(
                children: [
                  Container(
                    width: r.isPhone ? 50 : 62,
                    height: r.isPhone ? 50 : 62,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6F00).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_rounded,
                      color: const Color(0xFFE65100),
                      size: r.isPhone ? 26 : 32,
                    ),
                  ),
                  SizedBox(width: r.isPhone ? 14 : 18),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🔥 Hot Summer Sale!',
                        style: TextStyle(
                          fontSize: r.titleFontSize,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFE65100),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Special Offers',
                        style: TextStyle(
                          fontSize: r.captionFontSize,
                          color: const Color(0xFFBF360C),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r.isPhone ? 12 : 16,
                            vertical: r.isPhone ? 5 : 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE65100),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Explore Deals',
                            style: TextStyle(
                              color: HomeColors.white,
                              fontSize: r.captionFontSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SponsoredBanner extends StatelessWidget {
  const SponsoredBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.hPad),
          child: Text(
            'Sponsored',
            style: TextStyle(
              fontSize: r.titleFontSize,
              fontWeight: FontWeight.w700,
              color: HomeColors.textDark,
            ),
          ),
        ),
        SizedBox(height: r.isPhone ? 10 : 14),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.hPad),
          child: Container(
            height: r.sponsoredHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF37474F), Color(0xFF263238)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(r.borderRadius),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '– UP TO –',
                    style: TextStyle(
                      color: HomeColors.white.withOpacity(0.6),
                      fontSize: r.captionFontSize,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    '50% OFF',
                    style: TextStyle(
                      color: HomeColors.white,
                      fontSize: r.isPhone ? 38 : 50,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.isPhone ? 20 : 28,
                        vertical: r.isPhone ? 8 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: HomeColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'up to 50% Off  →',
                        style: TextStyle(
                          color: HomeColors.textDark,
                          fontWeight: FontWeight.w700,
                          fontSize: r.captionFontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
