import 'package:flutter/material.dart';
import 'export_allthings.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.favorite_border_rounded, label: 'Wishlist'),
    (icon: Icons.shopping_cart_outlined, label: 'Cart'),
    (icon: Icons.search_rounded, label: 'Search'),
    (icon: Icons.settings_outlined, label: 'Setting'),
  ];

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);
    return Container(
      height: r.bottomNavHeight,
      decoration: BoxDecoration(
        color: HomeColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _items.length,
          (i) => _NavBtn(
            icon: _items[i].icon,
            label: _items[i].label,
            selected: currentIndex == i,
            onTap: () => onTap(i),
            r: r,
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.r,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final HomeResponsive r;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: r.isPhone ? 60 : 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(r.isPhone ? 6 : 8),
              decoration: BoxDecoration(
                color: selected
                    ? HomeColors.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected ? HomeColors.primary : HomeColors.textMid,
                size: r.isPhone ? 22 : 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: r.isPhone ? 10 : 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? HomeColors.primary : HomeColors.textMid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
