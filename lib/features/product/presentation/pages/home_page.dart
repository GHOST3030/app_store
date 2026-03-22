import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/product_providers.dart';
import '../widgets/export_allthings.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _navIndex = 0;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.extentAfter < 200) {
      ref.read(productNotifierProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.white,
      appBar: const HomeAppBar(),
      body: _body(),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  Widget _body() {
    final r = HomeResponsive.of(context);

    return RefreshIndicator(
      color: HomeColors.primary,
      onRefresh: () => ref.read(productNotifierProvider.notifier).refresh(),
      child: CustomScrollView(
        controller: _scroll,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: r.isPhone ? 12 : 16),

                // Search bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: r.hPad),
                  child: const HomeSearchBar(),
                ),

                SizedBox(height: r.sectionGap * 0.75),

                // Categories + Sort/Filter
                const CategoriesSection(),

                SizedBox(height: r.sectionGap),

                // // Promo carousel
                const PromoBanner(),

                SizedBox(height: r.sectionGap),

                // // Deal of the Day
                const DealOfTheDaySection(),

                SizedBox(height: r.sectionGap),

                // Special offers banner
                // const SpecialOffersBanner(),
                // SizedBox(height: r.isPhone ? 14 : 18),

                // // Flat & Heels banner
                // const FlatAndHeelsBanner(),

                // SizedBox(height: r.sectionGap),

                // // Trending products grid
                // const TrendingProductsSection(),

                // SizedBox(height: r.sectionGap),

                // // Hot Summer Sale
                // const HotSummerSaleBanner(),

                // SizedBox(height: r.sectionGap),

                // // New Arrivals (featured products)
                // const NewArrivalsSection(),

                // SizedBox(height: r.sectionGap),

                // // Sponsored
                // const SponsoredBanner(),

                // SizedBox(height: r.sectionGap + 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
