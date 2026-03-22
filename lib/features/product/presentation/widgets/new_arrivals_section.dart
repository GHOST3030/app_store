import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/product_providers.dart';
import 'export_allthings.dart';
import 'product_card.dart';
import 'section_header.dart';

class NewArrivalsSection extends ConsumerWidget {
  const NewArrivalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = HomeResponsive.of(context);
    final featured = ref.watch(productNotifierProvider).featuredProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'New Arrivals',
          subtitle: "Summer '25 Collections",
          onViewAll: () {},
        ),
        SizedBox(height: r.isPhone ? 14 : 18),
        if (featured.isEmpty)
          const SizedBox(
            height: 60,
            child: Center(
              child: Text('No new arrivals',
                  style: TextStyle(color: HomeColors.textMid)),
            ),
          )
        else
          SizedBox(
            height: r.dealListHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: r.hPad),
              itemCount: featured.length,
              separatorBuilder: (_, __) => SizedBox(width: r.gridSpacing),
              itemBuilder: (_, i) => ProductCard(product: featured[i]),
            ),
          ),
      ],
    );
  }
}
