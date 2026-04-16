import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/product_providers.dart';
import 'export_allthings.dart';

import 'product_card.dart';

class SpecialOffersSection extends ConsumerWidget {
  const SpecialOffersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = HomeResponsive.of(context);
    final specialOffers = ref.watch(specialOffersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpecialOffersBanner(),
        SizedBox(height: r.isPhone ? 14 : 18),
        if (specialOffers.isEmpty)
          const SizedBox.shrink()
        else
          SizedBox(
            height: r.dealListHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: r.hPad),
              itemCount: specialOffers.length,
              separatorBuilder: (_, __) => SizedBox(width: r.gridSpacing),
              itemBuilder: (_, i) => ProductCard(product: specialOffers[i]),
            ),
          ),
      ],
    );
  }
}
