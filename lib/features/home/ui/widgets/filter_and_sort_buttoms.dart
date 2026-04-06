import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/constants/app_strings.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/features/home/ui/widgets/filtersheet/filter_sheet.dart';
import 'package:new_auth/features/home/ui/widgets/home_responsive.dart';
import 'package:new_auth/features/home/ui/widgets/sortsheet/sort_sheet.dart';

class FilterAndSortButtoms extends ConsumerWidget {
  const FilterAndSortButtoms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = HomeResponsive.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      child: Row(
        children: [
          Text(
            AppStrings.allFeatured,
            style: TextStyle(
              fontSize: r.titleFontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          _Chip(
            icon: Icons.sort_rounded,
            label: AppStrings.sort,
            onTap: () => _sortSheet(context, ref),
          ),
          const SizedBox(width: 8),
          _Chip(
            icon: Icons.filter_list_rounded,
            label: AppStrings.filter,
            onTap: () => _filterSheet(context, ref),
          ),
        ],
      ),
    );
  }
    void _sortSheet(BuildContext ctx, WidgetRef ref) => showModalBottomSheet(
    context: ctx,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SortSheet(ref: ref),
  );
  void _filterSheet(BuildContext ctx, WidgetRef ref) => showModalBottomSheet(
    context: ctx,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => FilterSheet(ref: ref),
  );
  
}
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
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: AppColors.textMid),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMid,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
