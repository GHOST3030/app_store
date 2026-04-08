import 'package:flutter/material.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
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
          gradient: AppColors.summerSaleGradient,
          borderRadius: BorderRadius.circular(r.borderRadius),
          border: Border.all(color: AppColors.bannerBorder),
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
                  color: AppColors.white.withValues(alpha: 0.25),
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
                      color: AppColors.summerSaleIcon.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_rounded,
                      color: AppColors.summerSaleIcon,
                      size: r.isPhone ? 26 : 32,
                    ),
                  ),
                  SizedBox(width: r.isPhone ? 14 : 18),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.hotSummerSale,
                        style: TextStyle(
                          fontSize: r.titleFontSize,
                          fontWeight: FontWeight.w900,
                          color: AppColors.summerSaleIcon,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.specialOffers,
                        style: TextStyle(
                          fontSize: r.captionFontSize,
                          color: AppColors.summerSaleSub,
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
                            color: AppColors.summerSaleIcon,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            context.l10n.exploreDeals,
                            style: TextStyle(
                              color: AppColors.white,
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
            context.l10n.sponsored,
            style: TextStyle(
              fontSize: r.titleFontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
        SizedBox(height: r.isPhone ? 10 : 14),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.hPad),
          child: Container(
            height: r.sponsoredHeight,
            decoration: BoxDecoration(
              gradient: AppColors.sponsoredGradient,
              borderRadius: BorderRadius.circular(r.borderRadius),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.upTo,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.6),
                      fontSize: r.captionFontSize,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    context.l10n.fiftyPercentOff,
                    style: TextStyle(
                      color: AppColors.white,
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
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.l10n.upToFiftyPercentOff,
                        style: TextStyle(
                          color: AppColors.textDark,
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
