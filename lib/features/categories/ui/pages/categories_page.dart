import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/features/product/logic/product_providers.dart';
import 'package:new_auth/features/home/ui/widgets/home_responsive.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Cat {
  final String label;
  final IconData icon;
  final Color color;
  final int id;
  const _Cat(this.label, this.icon, this.color, this.id);
}

List<_Cat> _getCats(BuildContext context) => [
  _Cat(
    context.l10n.beauty,
    Icons.face_retouching_natural,
    AppColors.catBeauty,
    1,
  ),
  _Cat(context.l10n.fashion, Icons.checkroom_rounded, AppColors.catFashion, 2),
  _Cat(context.l10n.kids, Icons.child_care_rounded, AppColors.catKids, 3),
  _Cat(context.l10n.mens, Icons.man_rounded, AppColors.catMens, 4),
  _Cat(context.l10n.womens, Icons.woman_rounded, AppColors.catWomens, 5),
];

// ─── Main widget ──────────────────────────────────────────────────────────────

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = HomeResponsive.of(context);
    final selectedId = ref.watch(productQueryProvider).categoryId;
    final cats = _getCats(context);

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
          child: Icon(
            cat.icon,
            color: selected ? AppColors.white : cat.color,
            size: r.categoryIconSize,
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

// ─── Header chip ──────────────────────────────────────────────────────────────


// ─── Sort sheet ───────────────────────────────────────────────────────────────

// ─── Filter sheet ─────────────────────────────────────────────────────────────

