import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_query.dart';
import '../../logic/product_providers.dart';
import 'export_allthings.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Cat {
  final String label;
  final IconData icon;
  final Color color;
  final String id;
  const _Cat(this.label, this.icon, this.color, this.id);
}

const _cats = [
  _Cat('Beauty', Icons.face_retouching_natural, Color(0xFFFF80AB), 'beauty'),
  _Cat('Fashion', Icons.checkroom_rounded, Color(0xFFE91E63), 'fashion'),
  _Cat('Kids', Icons.child_care_rounded, Color(0xFF42A5F5), 'kids'),
  _Cat('Mens', Icons.man_rounded, Color(0xFF5C6BC0), 'mens'),
  _Cat('Womens', Icons.woman_rounded, Color(0xFFAB47BC), 'womens'),
];

// ─── Main widget ──────────────────────────────────────────────────────────────

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = HomeResponsive.of(context);
    final selectedId = ref.watch(productNotifierProvider).query.categoryId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.hPad),
          child: Row(
            children: [
              Text(
                'All Featred',
                style: TextStyle(
                  fontSize: r.titleFontSize,
                  fontWeight: FontWeight.w700,
                  color: HomeColors.textDark,
                ),
              ),
              const Spacer(),
              _Chip(
                icon: Icons.sort_rounded,
                label: 'Sort',
                onTap: () => _sortSheet(context, ref),
              ),
              const SizedBox(width: 8),
              _Chip(
                icon: Icons.filter_list_rounded,
                label: 'Filter',
                onTap: () => _filterSheet(context, ref),
              ),
            ],
          ),
        ),

        SizedBox(height: r.isPhone ? 14 : 18),

        // Bubbles
        SizedBox(
          height: r.categoryListHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: r.hPad),
            itemCount: _cats.length,
            separatorBuilder: (_, __) => SizedBox(width: r.categorySpacing),
            itemBuilder: (_, i) {
              final cat = _cats[i];
              final selected = selectedId == cat.id;
              return GestureDetector(
                onTap: () {
                  final n = ref.read(productNotifierProvider.notifier);
                  selected
                      ? n.setFilter(clearCategoryId: true)
                      : n.setFilter(categoryId: cat.id);
                },
                child: _Bubble(cat: cat, selected: selected, r: r),
              );
            },
          ),
        ),
      ],
    );
  }

  void _sortSheet(BuildContext ctx, WidgetRef ref) => showModalBottomSheet(
    context: ctx,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _SortSheet(ref: ref),
  );

  void _filterSheet(BuildContext ctx, WidgetRef ref) => showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _FilterSheet(ref: ref),
  );
}

// ─── Bubble ───────────────────────────────────────────────────────────────────

class _Bubble extends StatelessWidget {
  const _Bubble({required this.cat, required this.selected, required this.r});
  final _Cat cat;
  final bool selected;
  final HomeResponsive r;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: r.categoryBubbleSize,
          height: r.categoryBubbleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? cat.color : cat.color.withOpacity(0.10),
            border: Border.all(
              color: selected ? cat.color : cat.color.withOpacity(0.25),
              width: selected ? 2.5 : 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: cat.color.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            cat.icon,
            color: selected ? HomeColors.white : cat.color,
            size: r.categoryIconSize,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          cat.label,
          style: TextStyle(
            fontSize: r.captionFontSize,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? cat.color : HomeColors.textMid,
          ),
        ),
      ],
    );
  }
}

// ─── Header chip ──────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: HomeColors.divider),
          borderRadius: BorderRadius.circular(8),
          color: HomeColors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: HomeColors.textMid),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: HomeColors.textMid,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sort sheet ───────────────────────────────────────────────────────────────

class _SortSheet extends StatelessWidget {
  const _SortSheet({required this.ref});
  final WidgetRef ref;

  static const _opts = [
    (
      label: 'Price: Low → High',
      field: ProductSortField.price,
      order: SortOrder.asc,
    ),
    (
      label: 'Price: High → Low',
      field: ProductSortField.price,
      order: SortOrder.desc,
    ),
    (label: 'Top Rated', field: ProductSortField.rating, order: SortOrder.desc),
    (
      label: 'Newest First',
      field: ProductSortField.newest,
      order: SortOrder.desc,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
       // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HomeColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ..._opts.map(
            (o) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                o.label,
                style: const TextStyle(
                  fontSize: 14,
                  color: HomeColors.textDark,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: HomeColors.textMid,
              ),
              onTap: () {
                ref
                    .read(productNotifierProvider.notifier)
                    .setSort(sortBy: o.field, order: o.order);
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Clear Sort',
              style: TextStyle(
                fontSize: 14,
                color: HomeColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              ref.read(productNotifierProvider.notifier).clearSort();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Filter sheet ─────────────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.ref});
  final WidgetRef ref;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  RangeValues _price = const RangeValues(0, 5000);
  double _rating = 0;
  bool _inStock = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HomeColors.textDark,
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: HomeColors.textDark,
            ),
          ),
          RangeSlider(
            values: _price,
            min: 0,
            max: 5000,
            divisions: 50,
            activeColor: HomeColors.primary,
            labels: RangeLabels(
              '₹${_price.start.round()}',
              '₹${_price.end.round()}',
            ),
            onChanged: (v) => setState(() => _price = v),
          ),

          const SizedBox(height: 8),
          const Text(
            'Min Rating',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: HomeColors.textDark,
            ),
          ),
          Slider(
            value: _rating,
            min: 0,
            max: 5,
            divisions: 10,
            activeColor: HomeColors.starYellow,
            label: _rating == 0 ? 'Any' : _rating.toStringAsFixed(1),
            onChanged: (v) => setState(() => _rating = v),
          ),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'In Stock Only',
              style: TextStyle(fontSize: 13, color: HomeColors.textDark),
            ),
            value: _inStock,
            activeThumbColor: HomeColors.primary,
            onChanged: (v) => setState(() => _inStock = v),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                widget.ref
                    .read(productNotifierProvider.notifier)
                    .setFilter(
                      minPrice: _price.start > 0 ? _price.start : null,
                      maxPrice: _price.end < 5000 ? _price.end : null,
                      minRating: _rating > 0 ? _rating : null,
                      onlyAvailable: _inStock ? true : null,
                    );
                Navigator.pop(context);
              },
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: HomeColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
