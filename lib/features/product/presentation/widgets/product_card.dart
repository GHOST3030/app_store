import 'package:flutter/material.dart';

import '../../data/product_model.dart';

/// Displays a single [ProductModel].
/// No Riverpod, no backend — pure presentational widget.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final void Function(String id)? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ──────────────────────────────────────────────────────
          _Thumbnail(imageUrl: product.imageUrl),

          // ── Details ────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Badge(
                        icon: Icons.attach_money,
                        label: product.price.toStringAsFixed(2),
                        color: const Color(0xFF6C63FF),
                      ),
                      const SizedBox(width: 8),
                      _Badge(
                        icon: Icons.inventory_2_outlined,
                        label: 'Qty ${product.quantity}',
                        color: const Color(0xFF00B4AD),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Delete ─────────────────────────────────────────────────────────
          if (onDelete != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 4),
              child: IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 22),
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        title: const Text('Delete Product',
            style: TextStyle(color: Colors.white)),
        content: Text('Delete "${product.name}"?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete?.call(product.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─── Private sub-widgets ─────────────────────────────────────────────────────

class _Thumbnail extends StatelessWidget {
  final String imageUrl;
  const _Thumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFF252535),
        child: const Icon(Icons.image_not_supported_outlined,
            color: Colors.white24, size: 36),
      );
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
