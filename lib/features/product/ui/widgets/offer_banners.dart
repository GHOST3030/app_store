import 'package:flutter/material.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
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
          gradient: AppColors.specialOffersGradient,
          borderRadius: BorderRadius.circular(r.borderRadius),
          border: Border.all(color: AppColors.bannerBorder, width: 1.2),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(r.isPhone ? 12 : 16),
              child: Container(
                width: r.isPhone ? 58 : 70,
                height: r.isPhone ? 58 : 70,
                decoration: BoxDecoration(
                  color: AppColors.specialOfferIcon.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_offer_rounded,
                  color: AppColors.specialOfferIcon,
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
                    context.l10n.specialOffersFire,
                    style: TextStyle(
                      fontSize: r.bodyFontSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.l10n.offerAtBestPrices,
                    style: TextStyle(
                      fontSize: r.captionFontSize,
                      color: AppColors.textMid,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: r.isPhone ? 12 : 16),
              child: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMid, size: 22),
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
          gradient: AppColors.flatHeelsGradient,
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
                  color: AppColors.white.withValues(alpha: 0.10),
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
                    color: AppColors.white,
                  ),
                  SizedBox(width: r.isPhone ? 14 : 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.flatAndHeels,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: r.titleFontSize,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          context.l10n.standAChanceToBeRewarded,
                          style: TextStyle(
                            color: AppColors.white,
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
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.l10n.visitNow,
                        style: TextStyle(
                          color: AppColors.primary,
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
