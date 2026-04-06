import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_model.dart';
import '../../logic/product_providers.dart';
import 'export_allthings.dart';
import 'product_card.dart';

class TrendingProductsSection extends ConsumerWidget {
  const TrendingProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    final isLoading = ref.watch(productIsLoadingProvider);
    final isLoadingMore = ref.watch(productIsLoadingMoreProvider);
    final hasMore = ref.watch(productHasMoreProvider);
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
                        AppStrings.trendingProducts,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: r.bodyFontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        AppStrings.lastDate,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.85),
                          fontSize: r.captionFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        AppStrings.viewAll,
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

        // ── Grid content ────────────────────────────────────────────────────
        Buildcontent(ctx: context, ref: ref, products: products, isLoading: isLoading, isLoadingMore: isLoadingMore, hasMore: hasMore, r: r),
      ],
    );
  }
}

class Buildcontent extends StatelessWidget {
  const Buildcontent({
    super.key,
    required this.ctx,
    required this.ref,
    required this.products,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.r,
  });

  final BuildContext ctx;
  final WidgetRef ref;
  final List<ProductModel> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final HomeResponsive r;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return BuildShimmerGrid(r: r);
    }

    if (products.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: Text(
            AppStrings.noProducts,
            style: TextStyle(color: AppColors.textMid),
          ),
        ),
      );
    }

    final displayedProducts = products.take(r.productGridCols * 2).toList();
    final cardWidth =
        (MediaQuery.sizeOf(ctx).width - r.hPad * 2 - r.gridSpacing * (r.productGridCols - 1)) /
            r.productGridCols;
    final cardHeight = cardWidth / r.gridCardAspectRatio;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.hPad),
          child: Wrap(
            spacing: r.gridSpacing,
            runSpacing: r.gridSpacing,
            children: [
              for (final product in displayedProducts)
                SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: ProductCard(product: product),
                ),
            ],
          ),
        ),

        if (hasMore) ...[
          SizedBox(height: r.isPhone ? 16 : 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.hPad),
            child: isLoadingMore
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          ref.read(productNotifierProvider.notifier).loadMore(),
                      child: const Text(
                        AppStrings.loadMore,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ],
    );
  }
}

class BuildShimmerGrid extends StatelessWidget {
  const BuildShimmerGrid({
    super.key,
    required this.r,
  });

  final HomeResponsive r;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      child: Wrap(
        spacing: r.gridSpacing,
        runSpacing: r.gridSpacing,
        children: List.generate(
          r.productGridCols * 2,
          (_) => Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.bgGrey,
              borderRadius: BorderRadius.circular(r.borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
