import 'package:flutter/material.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/features/product/data/product_model.dart';

class ProductDealCard extends StatelessWidget {
  const ProductDealCard({
    super.key,
    required this.product,
    this.width = 160,
    this.onTap,
  });

  final ProductModel product;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPrice != null &&
        product.discountPrice! < product.price;
    final discountPct = hasDiscount
        ? (((product.price - product.discountPrice!) / product.price) * 100)
            .round()
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
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
            // ── Image ──────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: product.images.isNotEmpty
                      ? Image.network(
                          product.images.first,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _ImagePlaceholder(width: width),
                        )
                      : _ImagePlaceholder(width: width),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.badge,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$discountPct% ${context.l10n.off}',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
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
                        BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.08),
                            blurRadius: 4)
                      ],
                    ),
                    child: const Icon(Icons.favorite_border_rounded,
                        size: 14, color: AppColors.primary),
                  ),
                ),
              ],
            ),

            // ── Info ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Rating row
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.starYellow, size: 13),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textMid),
                      ),
                      const Spacer(),
                      if (product.stock == 0)
                        Text(
                          context.l10n.outOfStock,
                          style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.badge,
                              fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Price row
                  if (hasDiscount) ...[
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.priceOld,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      '₹${product.discountPrice!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ] else
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 120,
      color: AppColors.bgGrey,
      child: const Icon(Icons.image_not_supported_outlined,
          color: AppColors.priceOld, size: 32),
    );
  }
}
