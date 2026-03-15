import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_auth/features/product/data/product_query.dart';
import 'package:new_auth/features/product/logic/product_notifier.dart';
import 'package:new_auth/features/product/logic/product_providers.dart';
import 'package:new_auth/features/product/logic/product_state.dart';
import 'package:new_auth/features/product/presentation/widgets/featured_products_section.dart';
import 'package:new_auth/features/product/presentation/widgets/filter_bottom_sheet.dart';
import 'package:new_auth/features/product/presentation/widgets/product_card.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load on first mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productNotifierProvider.notifier).loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);
    final notifier = ref.read(productNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          // Sort dropdown
          _SortButton(
            current: state.query.sortBy,
            currentOrder: state.query.sortOrder,
            onSort: (field, order) => notifier.setSort(sortBy: field, order: order),
            onClear: notifier.clearSort,
          ),
          // Filter button
          IconButton(
            icon: Badge(
              isLabelVisible: state.query.hasActiveFilters,
              child: const Icon(Icons.filter_list),
            ),
            tooltip: 'Filters',
            onPressed: () => _openFilters(context, state.query, notifier),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ── Search bar ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search products…',
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          notifier.clearSearch();
                        },
                      ),
                  ],
                  onChanged: (value) => notifier.search(value),
                ),
              ),
            ),

            // ── Featured section ─────────────────────────────────────────
            if (state.featuredProducts.isNotEmpty)
              SliverToBoxAdapter(
                child: FeaturedProductsSection(
                  products: state.featuredProducts,
                  onTap: (id) => context.push('/product/$id'),
                ),
              ),

            // ── Active filter chips ──────────────────────────────────────
            if (state.query.hasActiveFilters)
              SliverToBoxAdapter(
                child: _ActiveFilterChips(
                  query: state.query,
                  onClear: notifier.clearFilters,
                ),
              ),

            // ── Product grid ─────────────────────────────────────────────
            _buildProductGrid(state, context),

            // ── Load more indicator ──────────────────────────────────────
            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

            // ── End of list ──────────────────────────────────────────────
            if (state.isSuccess && !state.hasMore && state.products.isNotEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'You\'ve seen all products',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductState state, BuildContext context) {
    if (state.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isFailure) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(state.errorMessage ?? 'Something went wrong'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () =>
                    ref.read(productNotifierProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text('No products found',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = state.products[index];
            return ProductCard(
              product: product,
              onTap: () => context.push('/product/${product.id}'),
            );
          },
          childCount: state.products.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
      ),
    );
  }

  void _openFilters(
    BuildContext context,
    ProductQuery current,
    ProductNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => FilterBottomSheet(
        current: current,
        onApply: ({
          double? minPrice,
          double? maxPrice,
          double? minRating,
          bool? onlyAvailable,
        }) {
          notifier.setFilter(
            minPrice: minPrice,
            maxPrice: maxPrice,
            minRating: minRating,
            onlyAvailable: onlyAvailable,
          );
        },
        onClear: notifier.clearFilters,
      ),
    );
  }
}

// ─── Sort button ──────────────────────────────────────────────────────────────

class _SortButton extends StatelessWidget {
  final ProductSortField? current;
  final SortOrder currentOrder;
  final void Function(ProductSortField, SortOrder) onSort;
  final VoidCallback onClear;

  const _SortButton({
    required this.current,
    required this.currentOrder,
    required this.onSort,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Badge(
        isLabelVisible: current != null,
        child: const Icon(Icons.sort),
      ),
      tooltip: 'Sort',
      onSelected: (value) {
        if (value == 'clear') {
          onClear();
          return;
        }
        final parts = value.split('_');
        final field = _fieldFromString(parts[0]);
        final order =
            parts[1] == 'asc' ? SortOrder.asc : SortOrder.desc;
        onSort(field, order);
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'price_asc', child: Text('Price: Low → High')),
        const PopupMenuItem(value: 'price_desc', child: Text('Price: High → Low')),
        const PopupMenuItem(value: 'rating_desc', child: Text('Top Rated')),
        const PopupMenuItem(value: 'newest_desc', child: Text('Newest')),
        if (current != null) ...[
          const PopupMenuDivider(),
          const PopupMenuItem(value: 'clear', child: Text('Clear Sort')),
        ],
      ],
    );
  }

  ProductSortField _fieldFromString(String s) {
    switch (s) {
      case 'price':
        return ProductSortField.price;
      case 'rating':
        return ProductSortField.rating;
      default:
        return ProductSortField.newest;
    }
  }
}

// ─── Active filter chips ──────────────────────────────────────────────────────

class _ActiveFilterChips extends StatelessWidget {
  final ProductQuery query;
  final VoidCallback onClear;

  const _ActiveFilterChips({required this.query, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 6,
              children: [
                if (query.minPrice != null || query.maxPrice != null)
                  Chip(
                    label: Text(
                      'Price: ${query.minPrice?.toStringAsFixed(0) ?? '0'}'
                      ' – ${query.maxPrice?.toStringAsFixed(0) ?? '∞'}',
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                if (query.minRating != null)
                  Chip(
                    label: Text('★ ${query.minRating!.toStringAsFixed(1)}+'),
                    visualDensity: VisualDensity.compact,
                  ),
                if (query.onlyAvailable == true)
                  const Chip(
                    label: Text('In Stock'),
                    visualDensity: VisualDensity.compact,
                  ),
                if (query.onlyFeatured == true)
                  const Chip(
                    label: Text('Featured'),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
          TextButton(onPressed: onClear, child: const Text('Clear all')),
        ],
      ),
    );
  }
}
