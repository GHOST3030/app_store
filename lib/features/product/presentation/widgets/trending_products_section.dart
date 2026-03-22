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
              gradient: HomeColors.trendingGradient,
              borderRadius: BorderRadius.circular(r.borderRadius),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: HomeColors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trending Products',
                        style: TextStyle(
                          color: HomeColors.white,
                          fontSize: r.bodyFontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Last Date 29/02/22',
                        style: TextStyle(
                          color: HomeColors.white.withOpacity(0.85),
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
                        'View all',
                        style: TextStyle(
                          color: HomeColors.white,
                          fontSize: r.captionFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: HomeColors.white,
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

        // ── Adaptive grid ───────────────────────────────────────────────────
        _buildGrid(
          context, ref, products, isLoading, isLoadingMore, hasMore, r,
        ),
      ],
    );
  }

  Widget _buildGrid(
    BuildContext ctx,
    WidgetRef ref,
    List<ProductModel> products,
    bool isLoading,
    bool isLoadingMore,
    bool hasMore,
    HomeResponsive r,
  ) {
    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: r.hPad),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: r.productGridCols,
          childAspectRatio: r.gridCardAspectRatio,
          crossAxisSpacing: r.gridSpacing,
          mainAxisSpacing: r.gridSpacing,
        ),
        itemCount: r.productGridCols * 2,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: HomeColors.bgGrey,
            borderRadius: BorderRadius.circular(r.borderRadius),
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return SizedBox(
        height: 80,
        child: const Center(
          child: Text(
            'No products',
            style: TextStyle(color: HomeColors.textMid),
          ),
        ),
      );
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: r.hPad),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: r.productGridCols,
            childAspectRatio: r.gridCardAspectRatio,
            crossAxisSpacing: r.gridSpacing,
            mainAxisSpacing: r.gridSpacing,
          ),
          itemCount: products.take(r.productGridCols * 2).length,
          itemBuilder: (_, i) => ProductCard(product: products[i]),
        ),

        if (hasMore) ...[
          SizedBox(height: r.isPhone ? 16 : 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.hPad),
            child: isLoadingMore
                ? const Center(
                    child: CircularProgressIndicator(
                      color: HomeColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: HomeColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          ref.read(productNotifierProvider.notifier).loadMore(),
                      child: const Text(
                        'Load More',
                        style: TextStyle(
                          color: HomeColors.primary,
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
