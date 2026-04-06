import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/features/categories/ui/pages/categories_page.dart';
import 'package:new_auth/features/home/ui/widgets/filter_and_sort_buttoms.dart';

import '../../../product/logic/product_providers.dart';
import '../../../product/logic/product_state.dart';
import '../../../product/ui/widgets/export_allthings.dart';

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
    // Handle AsyncError from main provider
    ref.listen(productNotifierProvider, (prev, next) {
      if (next is AsyncError) {
        _showErrorSnackBar(
          context,
          '${AppStrings.failedToLoadProducts} ${next.failure ?? ''}',
          retry: () => ref.read(productNotifierProvider.notifier).refresh(),
        );
      }
    });

    // Handle ProductFailure from loadMore() errors
    ref.listen(productFailureProvider, (prev, next) {
      if (next != null && prev != next) {
        final message = switch (next) {
          NetworkFailure() => AppStrings.networkError,
          ServerFailure() => AppStrings.serverError,
          UnknownFailure() => next.message ?? AppStrings.unknownFailure,
        };
        _showErrorSnackBar(
          context,
          message,
          retry: () => ref.read(productNotifierProvider.notifier).loadMore(),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const HomeAppBar(),
      body: Homewidget(context: context, ref: ref, scroll: _scroll),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  void _showErrorSnackBar(
    BuildContext context,
    String message, {
    VoidCallback? retry,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: retry != null
            ? SnackBarAction(
                label: AppStrings.retry,
                textColor: AppColors.white,
                onPressed: retry,
              )
            : null,
      ),
    );
  }
}

class Homewidget extends StatelessWidget {
  const Homewidget({
    super.key,
    required this.context,
    required this.ref,
    required ScrollController scroll,
  }) : _scroll = scroll;

  final BuildContext context;
  final WidgetRef ref;
  final ScrollController _scroll;

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);

    return RefreshIndicator(
      color: AppColors.primary,
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

                //  Sort/Filter
                FilterAndSortButtoms(),
                SizedBox(height: r.sectionGap),

                //Categories
                const CategoriesSection(),
                SizedBox(height: r.sectionGap),

                // Promo carousel
                //   const PromoBanner(),
                SizedBox(height: r.sectionGap),

                // Deal of the Day
                const DealOfTheDaySection(),

                // SizedBox(height: r.sectionGap),

                // // Special offers banner
                // const SpecialOffersBanner(),
                // SizedBox(height: r.isPhone ? 14 : 18),

                // // Flat & Heels banner
                // const FlatAndHeelsBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
