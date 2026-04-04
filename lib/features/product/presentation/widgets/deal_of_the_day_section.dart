import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/deal_timer_notifier.dart';
import '../../logic/product_providers.dart';
import 'export_allthings.dart';
import 'product_card.dart';

class DealOfTheDaySection extends ConsumerWidget {
  const DealOfTheDaySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              gradient: HomeColors.dealBannerGradient,
              borderRadius: BorderRadius.circular(r.borderRadius),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: HomeColors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deal of the Day',
                        style: TextStyle(
                          color: HomeColors.white,
                          fontSize: r.bodyFontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CountdownText(r: r),
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

        // ── Product list ────────────────────────────────────────────────────
        SizedBox(
          height: r.dealListHeight,
          child: ProductlistView(r: r),
        ),
      ],
    );
  }
}

class ProductlistView extends ConsumerStatefulWidget {
  const ProductlistView({super.key, required this.r});
  final HomeResponsive r;

  @override
  ConsumerState<ProductlistView> createState() => _ProductList(r: r);
}

// ignore: must_be_immutable
class _ProductList extends ConsumerState<ProductlistView> {
  final HomeResponsive r;
  final ScrollController scrollController = ScrollController();

  _ProductList({required this.r});
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onscroll);
    // Fetch products when the widget is first built
  }

  void _onscroll() {
    final notifier = ref.read(productNotifierProvider.notifier);
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListProvider);
    final isLoading = ref.watch(productIsLoadingProvider);
    if (isLoading) {
      return ListView.separated(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: r.hPad),
        itemCount: 4,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, _2) => SizedBox(width: r.gridSpacing),
        itemBuilder: (_, _2) => _ShimmerCard(r: r),
        cacheExtent: r.cardWidth * 3,
      );
    }

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No deals right now',
          style: TextStyle(color: HomeColors.textMid),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      itemCount: products.length + (isLoading ? 1 : 0),
      physics: const BouncingScrollPhysics(),
      cacheExtent: r.cardWidth * 3,
      separatorBuilder: (_, _2) => SizedBox(width: r.gridSpacing),
      itemBuilder: (_, i) {

        if(i == products.length) {
          return const SizedBox(
            width: 60,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: HomeColors.primary,
              ),
            ),
          );
        }
        return ProductCard(key: ValueKey(products[i].id), product: products[i]);
      },
    );
  }
}

// ─── Shimmer card ─────────────────────────────────────────────────────────────

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard({required this.r});
  final HomeResponsive r;

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.4,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, _2) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: r.cardWidth,
          decoration: BoxDecoration(
            color: HomeColors.bgGrey,
            borderRadius: BorderRadius.circular(r.borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: r.cardImageHeight,
                decoration: BoxDecoration(
                  color: HomeColors.divider,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(r.borderRadius),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Line(w: r.cardWidth * 0.75, h: 11),
                    const SizedBox(height: 6),
                    _Line(w: r.cardWidth * 0.5, h: 10),
                    const SizedBox(height: 6),
                    _Line(w: r.cardWidth * 0.4, h: 13),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.w, required this.h});
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: HomeColors.divider,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class CountdownText extends ConsumerWidget {
  const CountdownText({super.key, required this.r});

  final HomeResponsive r;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(dealTimerTextProvider);
    return Text(
      text,
      style: TextStyle(
        color: HomeColors.white.withValues(alpha: 0.85),
        fontSize: r.captionFontSize,
      ),
    );
  }
}

final dealTimerTextProvider = Provider<String>((ref) {
  final left = ref.watch(dealTimerProvider);

  String pad(int n) => n.toString().padLeft(2, '0');

  return '${pad(left.inHours)}h ${pad(left.inMinutes % 60)}m ${pad(left.inSeconds % 60)}s remaining';
});
