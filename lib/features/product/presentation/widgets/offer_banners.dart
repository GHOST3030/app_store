import 'package:flutter/material.dart';
import 'export_allthings.dart';

class SpecialOffersBanner extends StatelessWidget {
  const SpecialOffersBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      child: Container(
        height: r.specialOfferHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
          ),
          borderRadius: BorderRadius.circular(r.borderRadius),
          border: Border.all(color: const Color(0xFFFFD54F), width: 1.2),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(r.isPhone ? 12 : 16),
              child: Container(
                width: r.isPhone ? 58 : 70,
                height: r.isPhone ? 58 : 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F00).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_offer_rounded,
                  color: const Color(0xFFFF6F00),
                  size: r.isPhone ? 26 : 32,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Offers 🔥',
                    style: TextStyle(
                      fontSize: r.bodyFontSize,
                      fontWeight: FontWeight.w700,
                      color: HomeColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'We make sure you get the offer\nyou need at best prices',
                    style: TextStyle(
                      fontSize: r.captionFontSize,
                      color: HomeColors.textMid,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: r.isPhone ? 12 : 16),
              child: const Icon(Icons.chevron_right_rounded,
                  color: HomeColors.textMid, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}

class FlatAndHeelsBanner extends StatelessWidget {
  const FlatAndHeelsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      child: Container(
        height: r.flatHeelsHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF8BBD9), Color(0xFFE91E63)],
          ),
          borderRadius: BorderRadius.circular(r.borderRadius),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HomeColors.white.withOpacity(0.10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.isPhone ? 20 : 28,
                vertical: r.isPhone ? 16 : 20,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.dry_cleaning_rounded,
                    size: r.isPhone ? 38 : 48,
                    color: HomeColors.white,
                  ),
                  SizedBox(width: r.isPhone ? 14 : 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Flat and Heels',
                          style: TextStyle(
                            color: HomeColors.white,
                            fontSize: r.titleFontSize,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Stand a chance to get rewarded',
                          style: TextStyle(
                            color: HomeColors.white,
                            fontSize: r.captionFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.isPhone ? 14 : 18,
                        vertical: r.isPhone ? 8 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: HomeColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Visit now →',
                        style: TextStyle(
                          color: HomeColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: r.captionFontSize,
                        ),
                      ),
                    ),
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
