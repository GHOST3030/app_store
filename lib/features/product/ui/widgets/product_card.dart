import 'package:flutter/material.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/features/product/data/product_model.dart';
import 'export_allthings.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.width,
    this.onTap,
  });

  final ProductModel product;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);
    final w = width ?? r.cardWidth;
    final hasDiscount =
        product.discountPrice != null && product.discountPrice! < product.price;
    final pct = hasDiscount
        ? (((product.price - product.discountPrice!) / product.price) * 100).round()
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(r.borderRadius),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ─────────────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(r.borderRadius),
                  ),
                  child: product.images.isNotEmpty
                      ? Image.network(
                          product.images[0],
                          cacheWidth: 300,
                          width: double.infinity,
                          height: r.cardImageHeight,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _Placeholder(height: r.cardImageHeight),
                        )
                      : _Placeholder(height: r.cardImageHeight),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.badge,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$pct% ${context.l10n.off}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.black.withValues(alpha: 0.08), blurRadius: 4),
                      ],
                    ),
                    child: const Icon(Icons.favorite_border_rounded,
                        size: 14, color: AppColors.primary),
                  ),
                ),
              ],
            ),

            // ── Info ──────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(r.isPhone ? 10 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: r.captionFontSize + 1,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: r.isPhone ? 5 : 7),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.starYellow, size: 13),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                            fontSize: r.captionFontSize,
                            color: AppColors.textMid),
                      ),
                      const Spacer(),
                      if (product.stock == 0)
                        Text(
                          context.l10n.outOfStockShort,
                          style: TextStyle(
                              fontSize: r.captionFontSize - 1,
                              color: AppColors.badge,
                              fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                  SizedBox(height: r.isPhone ? 5 : 7),
                  if (hasDiscount) ...[
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: r.captionFontSize,
                        color: AppColors.priceOld,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      '₹${product.discountPrice!.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: r.priceFontSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ] else
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: r.priceFontSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
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

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: AppColors.bgGrey,
      child: const Icon(Icons.image_not_supported_outlined,
          color: AppColors.priceOld, size: 32),
    );
  }
}
