import 'package:flutter/material.dart';
import 'package:new_auth/features/product/data/product_query.dart';


class FilterBottomSheet extends StatefulWidget {
  final ProductQuery current;
  final void Function({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? onlyAvailable,
  }) onApply;
  final VoidCallback onClear;

  const FilterBottomSheet({
    super.key,
    required this.current,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _priceRange;
  late double _minRating;
  late bool _onlyAvailable;

  static const double _maxAllowedPrice = 10000;

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.current.minPrice ?? 0,
      widget.current.maxPrice ?? _maxAllowedPrice,
    );
    _minRating = widget.current.minRating ?? 0;
    _onlyAvailable = widget.current.onlyAvailable ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Filters',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    widget.onClear();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // ── Price range ──────────────────────────────────────
                Text('Price Range',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: _maxAllowedPrice,
                  divisions: 200,
                  labels: RangeLabels(
                    '\$${_priceRange.start.toStringAsFixed(0)}',
                    '\$${_priceRange.end.toStringAsFixed(0)}',
                  ),
                  onChanged: (v) => setState(() => _priceRange = v),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${_priceRange.start.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.grey)),
                    Text('\$${_priceRange.end.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Minimum rating ───────────────────────────────────
                Row(
                  children: [
                    Text('Minimum Rating',
                        style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(' ${_minRating.toStringAsFixed(1)}+'),
                      ],
                    ),
                  ],
                ),
                Slider(
                  value: _minRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  label: _minRating.toStringAsFixed(1),
                  onChanged: (v) => setState(() => _minRating = v),
                ),

                const SizedBox(height: 12),

                // ── Availability ─────────────────────────────────────
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('In Stock Only'),
                  subtitle: const Text('Hide out-of-stock products'),
                  value: _onlyAvailable,
                  onChanged: (v) => setState(() => _onlyAvailable = v),
                ),
              ],
            ),
          ),

          // Apply button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: _apply,
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _apply() {
    widget.onApply(
      minPrice: _priceRange.start > 0 ? _priceRange.start : null,
      maxPrice:
          _priceRange.end < _maxAllowedPrice ? _priceRange.end : null,
      minRating: _minRating > 0 ? _minRating : null,
      onlyAvailable: _onlyAvailable ? true : null,
    );
    Navigator.pop(context);
  }
}
