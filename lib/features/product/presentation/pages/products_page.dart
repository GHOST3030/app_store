import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/product_model.dart';
import '../../logic/product_providers.dart';
import '../widgets/product_card.dart';

/// Products listing page.
/// Uses [ConsumerWidget] — no setState, no direct backend knowledge.
class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A24),
        title: const Text(
          'Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: () =>
                ref.read(productControllerProvider.notifier).loadProducts(),
          ),
        ],
      ),
      body: asyncProducts.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
        ),
        error: (error, _) => _ErrorView(
          message: error.toString(),
          onRetry: () =>
              ref.read(productControllerProvider.notifier).loadProducts(),
        ),
        data: (products) => products.isEmpty
            ? const _EmptyView()
            : _ProductListView(products: products),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        onPressed: () => _showAddSheet(context, ref),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddProductSheet(ref: ref),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ProductListView extends ConsumerWidget {
  final List<ProductModel> products;
  const _ProductListView({required this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onDelete: (id) =>
              ref.read(productControllerProvider.notifier).deleteProduct(id),
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 72, color: Color(0xFF6C63FF)),
          const SizedBox(height: 16),
          Text('No products yet',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white70)),
          const SizedBox(height: 6),
          Text('Tap + to add your first product.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white38)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 60, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF)),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add Product Sheet ────────────────────────────────────────────────────────

class _AddProductSheet extends StatefulWidget {
  final WidgetRef ref;
  const _AddProductSheet({required this.ref});

  @override
  State<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<_AddProductSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);

    final product = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      quantity: int.parse(_qtyCtrl.text.trim()),
      imageUrl: _imageCtrl.text.trim(),
      createdAt: DateTime.now(),
    );

    await widget.ref
        .read(productControllerProvider.notifier)
        .addProduct(product);

    if (mounted) Navigator.of(context).pop();
  }

  InputDecoration _decor(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF252535),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'New Product',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _decor('Name'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _decor('Description'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _priceCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decor('Price'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _qtyCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decor('Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      int.tryParse(v ?? '') == null ? 'Invalid' : null,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imageCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _decor('Image URL (optional)'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child:
                          CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save Product',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
