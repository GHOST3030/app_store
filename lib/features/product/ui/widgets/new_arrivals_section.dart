import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_auth/core/extensions/l10n_extension.dart';
import '../../logic/product_providers.dart';
import '../pages/view_all_products_page.dart';
import 'export_allthings.dart';
import 'product_card.dart';
import 'section_header.dart';

class NewArrivalsSection extends ConsumerWidget {
  const NewArrivalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = HomeResponsive.of(context);
    final newArrivals = ref.watch(newArrivalsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.newArrivals,
          subtitle: context.l10n.summerCollections,
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllProductsPage(
                  title: context.l10n.newArrivals,
                  provider: newArrivalsProvider,
                ),
              ),
            );
          },
        ),
        SizedBox(height: r.isPhone ? 14 : 18),
        if (newArrivals.isEmpty)
           SizedBox(
            height: 60,
            child: Center(
              child: Text(context.l10n.noNewArrivals,
                  style: const TextStyle(color: AppColors.textMid)),
            ),
          )
        else
          SizedBox(
            height: r.dealListHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: r.hPad),
              itemCount: newArrivals.length,
              separatorBuilder: (_, __) => SizedBox(width: r.gridSpacing),
              itemBuilder: (_, i) => ProductCard(product: newArrivals[i]),
            ),
          ),
      ],
    );
  }
}
