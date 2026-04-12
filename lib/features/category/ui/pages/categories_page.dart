import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/features/category/logic/providers/catgory_provider.dart';
import 'package:new_auth/features/product/logic/product_providers.dart';
import 'package:new_auth/features/home/ui/widgets/home_responsive.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Cat {
  final String label;
  final String imageUrl;
  final Color color;
  final int id;
  const _Cat(this.label, this.imageUrl, this.color, this.id);
}

// ─── Main widget ──────────────────────────────────────────────────────────────

class CategoriesSection extends ConsumerStatefulWidget {
  const CategoriesSection({super.key});

  @override
  ConsumerState<CategoriesSection> createState() => _CategoriesSection();
}

class _CategoriesSection extends ConsumerState<CategoriesSection> {
  _CategoriesSection();
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(categoryNotifierProvider.notifier).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);
    final selectedId = ref.watch(productQueryProvider).categoryId;
    //  final cats = _getCats(context);

    //final state = ref.watch(categoryNotifierProvider);
    //final categories = state.categories;
    //  log("Categories loaded: ${categories.length}");
    final cats = ref.watch(
      categoryNotifierProvider.select(
        (state) => state.categories
            .map(
              (c) =>
                  _Cat(c.name, c.imageUrl, AppColors.primary, int.parse(c.id)),
            )
            .toList(),
      ),
    );
    log("Categories loaded: ${cats.length}");
    final error = ref.watch(
      categoryNotifierProvider.select((state) => state.error),
    );
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ref.read(categoryNotifierProvider.notifier).fetchCategories();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        SizedBox(height: r.isPhone ? 14 : 18),

        // Bubbles
        SizedBox(
          height: r.categoryListHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: r.hPad),
            itemCount: cats.length,
            separatorBuilder: (_, __) => SizedBox(width: r.categorySpacing),
            itemBuilder: (_, i) {
              final cat = cats[i];
              final selected = selectedId == cat.id.toString();
              return GestureDetector(
                onTap: () {
                  final n = ref.read(productNotifierProvider.notifier);
                  selected
                      ? n.setFilter(clearCategoryId: true)
                      : n.setFilter(categoryId: cat.id.toString());
                },
                child: _Bubble(cat: cat, selected: selected, r: r),
              );
            },
          ),
        ),
      ],
    );
  }
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
            color: selected ? cat.color : cat.color.withValues(alpha: 0.10),
            border: Border.all(
              color: selected ? cat.color : cat.color.withValues(alpha: 0.25),
              width: selected ? 2.5 : 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: cat.color.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: ClipOval(
            child: Image.network(
              cat.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: r.categoryIconSize,
                height: r.categoryIconSize,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  shape: BoxShape.circle,
                ),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: r.categoryIconSize,
                  height: r.categoryIconSize,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                );
              },
              // color: selected ? AppColors.white : cat.color,
              width: r.categoryIconSize,
              height: r.categoryIconSize,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          cat.label,
          style: TextStyle(
            fontSize: r.captionFontSize,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? cat.color : AppColors.textMid,
          ),
        ),
      ],
    );
  }
}
