
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/constants/app_strings.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/features/product/data/product_query.dart';
import 'package:new_auth/features/product/logic/product_providers.dart';
import 'package:new_auth/features/home/ui/widgets/home_responsive.dart';






class SortSheet extends StatelessWidget {
  const SortSheet({required this.ref});
  final WidgetRef ref;

  static const _opts = [
    (
      label: AppStrings.priceLowToHigh,
      field: ProductSortField.price,
      order: SortOrder.asc,
    ),
    (
      label: AppStrings.priceHighToLow,
      field: ProductSortField.price,
      order: SortOrder.desc,
    ),
    (
      label: AppStrings.topRated,
      field: ProductSortField.rating,
      order: SortOrder.desc,
    ),
    (
      label: AppStrings.newestFirst,
      field: ProductSortField.createdAt,
      order: SortOrder.desc,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final rr = HomeResponsive.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.sortBy,
            style: TextStyle(
              fontSize: rr.titleFontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ..._opts.map(
            (o) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                o.label,
                style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMid,
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
              AppStrings.clearSort,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
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
