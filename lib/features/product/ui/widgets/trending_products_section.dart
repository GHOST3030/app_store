import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_model.dart';
import '../../logic/product_providers.dart';
import 'export_allthings.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import '../pages/view_all_products_page.dart';
import 'product_card.dart';

class TrendingProductsSection extends ConsumerWidget {
  const TrendingProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingProducts = ref.watch(trendingProductsProvider);
    final isLoading = ref.watch(productIsLoadingProvider);
    final r = HomeResponsive.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Gradient header ─────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.hPad),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.isPhone ? 16 : 20,
              vertical: r.isPhone ? 12 : 14,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.trendingGradient,
              borderRadius: BorderRadius.circular(r.borderRadius),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.trendingProducts,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: r.bodyFontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        context.l10n.lastDate,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.85),
                          fontSize: r.captionFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewAllProductsPage(
                          title: context.l10n.trendingProducts,
                          provider: trendingProductsProvider,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        context.l10n.viewAll,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: r.captionFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.white,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: r.isPhone ? 14 : 18),

        // ── List content ────────────────────────────────────────────────────
        SizedBox(
          height: r.dealListHeight,
          child: _BuildHorizontalList(
            ctx: context,
            ref: ref,
            products: trendingProducts,
            isLoading: isLoading,
            r: r,
          ),
        ),
      ],
    );
  }
}

class _BuildHorizontalList extends StatelessWidget {
  const _BuildHorizontalList({
    required this.ctx,
    required this.ref,
    required this.products,
    required this.isLoading,
    required this.r,
  });

  final BuildContext ctx;
  final WidgetRef ref;
  final List<ProductModel> products;
  final bool isLoading;
  final HomeResponsive r;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return BuildShimmerList(r: r);
    }

    if (products.isEmpty) {
      return Center(
        child: Text(
          ctx.l10n.noProducts,
          style: const TextStyle(color: AppColors.textMid),
        ),
      );
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(width: r.gridSpacing),
      itemBuilder: (_, i) => ProductCard(product: products[i]),
    );
  }
}

class BuildShimmerList extends StatelessWidget {
  const BuildShimmerList({required this.r});
  final HomeResponsive r;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      itemCount: 4,
      separatorBuilder: (_, __) => SizedBox(width: r.gridSpacing),
      itemBuilder: (_, __) => Container(
        width: r.cardWidth,
        decoration: BoxDecoration(
          color: AppColors.bgGrey,
          borderRadius: BorderRadius.circular(r.borderRadius),
        ),
      ),
    );
  }
}

