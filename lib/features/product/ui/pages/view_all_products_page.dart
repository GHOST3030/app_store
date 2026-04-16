import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/theme/app_colors.dart';

import '../../../product/data/product_model.dart';
import 'package:new_auth/features/home/ui/widgets/home_responsive.dart';
import 'package:new_auth/features/product/ui/widgets/product_card.dart';

class ViewAllProductsPage extends ConsumerWidget {
  const ViewAllProductsPage({
    super.key,
    required this.title,
    required this.provider,
  });

  final String title;
  final Provider<List<ProductModel>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(provider);
    final r = HomeResponsive.of(context);

    if (products.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(context, r),
        body: const Center(
          child: Text(
            'No products found', 
            style: TextStyle(color: AppColors.textMid),
          ),
        ),
      );
    }

    final cardWidth =
        (MediaQuery.sizeOf(context).width - r.hPad * 2 - r.gridSpacing * (r.productGridCols - 1)) /
            r.productGridCols;
    final cardHeight = cardWidth / r.gridCardAspectRatio;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context, r),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: r.hPad, vertical: r.sectionGap),
        child: Wrap(
          spacing: r.gridSpacing,
          runSpacing: r.gridSpacing,
          children: [
            for (final product in products)
              SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: ProductCard(product: product),
              ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, HomeResponsive r) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: r.titleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
