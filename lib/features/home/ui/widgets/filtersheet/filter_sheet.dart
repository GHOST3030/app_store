import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import 'package:new_auth/core/theme/app_colors.dart';
import 'package:new_auth/features/product/logic/product_providers.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({required this.ref});
  final WidgetRef ref;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
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
          Text(
            context.l10n.filter,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            context.l10n.priceRange,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          RangeSlider(
            values: _price,
            min: 0,
            max: 5000,
            divisions: 50,
            activeColor: AppColors.primary,
            labels: RangeLabels(
              '₹${_price.start.round()}',
              '₹${_price.end.round()}',
            ),
            onChanged: (v) => setState(() => _price = v),
          ),

          const SizedBox(height: 8),
          Text(
            context.l10n.minRating,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          Slider(
            value: _rating,
            min: 0,
            max: 5,
            divisions: 10,
            activeColor: AppColors.starYellow,
            label: _rating == 0 ? context.l10n.any : _rating.toStringAsFixed(1),
            onChanged: (v) => setState(() => _rating = v),
          ),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              context.l10n.inStockOnly,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
            value: _inStock,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _inStock = v),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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
              child: Text(
                context.l10n.apply,
                style: const TextStyle(
                  color: AppColors.white,
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
